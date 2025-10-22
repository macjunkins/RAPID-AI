#!/usr/bin/env node

/**
 * RAPID-AI CLI
 * Requirements-Analysis-Planning-Implementation-Development with AI
 * Extracted from EmberCare's proven implementation
 */

const { Command } = require('commander');
const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const program = new Command();

program
  .name('rapid')
  .description('RAPID-AI: Requirements-Analysis-Planning-Implementation-Development with AI automation')
  .version('1.0.0');

program
  .command('init')
  .description('Initialize AI workflow in current project')
  .option('-t, --type <type>', 'Project type (flutter, react, python, go)', 'auto')
  .option('-a, --ai <tool>', 'Primary AI tool (copilot, claude, gpt4)', 'copilot')
  .action(async (options) => {
    console.log('🚀 Initializing AI workflow...');
    
    const projectType = options.type === 'auto' ? detectProjectType() : options.type;
    console.log(`📊 Project type: ${projectType}`);
    console.log(`🤖 AI tool: ${options.ai}`);
    
    initializeConfig(projectType, options.ai);
    
    console.log('✅ AI workflow initialized!');
    console.log('📝 Edit .ai-workflow.yaml to customize configuration');
  });

program
  .command('analyze')
  .description('Analyze a story/feature with AI')
  .argument('<epic>', 'Epic number')
  .argument('<story>', 'Story number')
  .argument('<title>', 'Story title')
  .option('-o, --output <file>', 'Output file path')
  .action(async (epic, story, title, options) => {
    console.log(`🤖 Analyzing Story ${epic}.${story}: ${title}`);
    
    const outputFile = options.output || `docs/discovery/story-${epic}-${story}-discovery.md`;
    runDiscovery(epic, story, title, outputFile);
  });

program
  .command('plan')
  .description('Generate implementation plan for a story')
  .argument('<epic>', 'Epic number')
  .argument('<story>', 'Story number')
  .argument('<title>', 'Story title')
  .option('-d, --discovery <file>', 'Discovery document to use')
  .option('-o, --output <file>', 'Output file path')
  .action(async (epic, story, title, options) => {
    console.log(`📋 Creating implementation plan for Story ${epic}.${story}`);
    
    const outputFile = options.output || `docs/plans/story-${epic}-${story}-plan.md`;
    const discoveryFile = options.discovery || `docs/discovery/story-${epic}-${story}-discovery.md`;
    
    runPlanning(epic, story, title, discoveryFile, outputFile);
  });

program
  .command('setup')
  .description('Complete story setup (analyze + plan + branch)')
  .argument('<epic>', 'Epic number')
  .argument('<story>', 'Story number')
  .argument('<title>', 'Story title')
  .action(async (epic, story, title) => {
    console.log(`🏗️ Setting up Story ${epic}.${story}: ${title}`);
    
    runCompleteSetup(epic, story, title);
  });

// Helper functions
function detectProjectType() {
  if (fs.existsSync('pubspec.yaml')) {
    return 'flutter';
  } else if (fs.existsSync('package.json')) {
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    if (pkg.dependencies?.react || pkg.devDependencies?.react) {
      return 'react';
    }
    return 'node';
  } else if (fs.existsSync('requirements.txt') || fs.existsSync('pyproject.toml')) {
    return 'python';
  } else if (fs.existsSync('go.mod')) {
    return 'go';
  }
  return 'generic';
}

function initializeConfig(projectType, aiTool) {
  const config = {
    project: {
      type: projectType,
      name: path.basename(process.cwd()),
      architecture: getDefaultArchitecture(projectType)
    },
    ai_tools: [aiTool],
    workflows: {
      story_analysis: {
        enabled: true,
        timeout: 120,
        outputs: [
          'docs/discovery/{epic}-{story}-discovery.md',
          'docs/plans/{epic}-{story}-plan.md'
        ]
      }
    },
    integrations: {
      vscode: {
        enabled: true,
        auto_open_files: true
      },
      git: {
        auto_branch: true,
        branch_pattern: 'story/{epic}-{story}-{slug}'
      }
    }
  };

  fs.writeFileSync('.ai-workflow.yaml', require('yaml').stringify(config));
  
  // Create necessary directories
  ['docs/discovery', 'docs/plans'].forEach(dir => {
    fs.mkdirSync(dir, { recursive: true });
  });
}

function getDefaultArchitecture(projectType) {
  switch (projectType) {
    case 'flutter':
      return ['bloc', 'drift'];
    case 'react':
      return ['hooks', 'context'];
    case 'python':
      return ['django', 'orm'];
    default:
      return [];
  }
}

function runDiscovery(epic, story, title, outputFile) {
  const scriptPath = getScriptPath('ai-discovery.sh');
  const cmd = `"${scriptPath}" "${epic}" "${story}" "${title}" "${outputFile}"`;
  
  try {
    execSync(cmd, { stdio: 'inherit' });
  } catch (error) {
    console.error('❌ Discovery failed:', error.message);
    process.exit(1);
  }
}

function runPlanning(epic, story, title, discoveryFile, outputFile) {
  const scriptPath = getScriptPath('ai-implementation-plan.sh');
  const cmd = `"${scriptPath}" "${epic}" "${story}" "${title}" "${discoveryFile}" "${outputFile}"`;
  
  try {
    execSync(cmd, { stdio: 'inherit' });
  } catch (error) {
    console.error('❌ Planning failed:', error.message);
    process.exit(1);
  }
}

function runCompleteSetup(epic, story, title) {
  console.log('📖 Step 1: Running discovery analysis...');
  runDiscovery(epic, story, title, `docs/discovery/story-${epic}-${story}-discovery.md`);
  
  console.log('📋 Step 2: Generating implementation plan...');
  runPlanning(epic, story, title, 
    `docs/discovery/story-${epic}-${story}-discovery.md`,
    `docs/plans/story-${epic}-${story}-plan.md`);
  
  console.log('✅ Complete setup finished!');
}

function getScriptPath(scriptName) {
  // Try to find the script in the framework installation
  const frameworkPath = path.join(__dirname, '..', 'core', 'scripts', scriptName);
  if (fs.existsSync(frameworkPath)) {
    return frameworkPath;
  }
  
  // Try local installation
  const localPath = path.join(process.cwd(), 'ai-dev-workflow', 'core', 'scripts', scriptName);
  if (fs.existsSync(localPath)) {
    return localPath;
  }
  
  throw new Error(`Script not found: ${scriptName}`);
}

program.parse();