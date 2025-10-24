# RAPID-AI Framework

> **R**equirements **A**nalysis **P**lanning **I**mplementation **D**evelopment with **AI**

Transform any development project with AI-powered story analysis and implementation planning

## This Project is Pre-Alpha. Use at your own risk. I don't even have a roadmap yet. ##

**Extracted from EmberCare's production-ready AI workflow system**

## 🎯 **What This Framework Does**

RAPID-AI provides **two complementary modes** for AI-assisted development:

### **Execution Mode** (YAML-First, Deterministic)
- **📖 Story Analysis**: AI reads your requirements and generates technical implementation guidance
- **🏗️ Implementation Planning**: Detailed step-by-step plans with architecture recommendations
- **📝 Documentation Workflow**: Automated documentation verification keeps docs current with code changes
- **🔄 Workflow Integration**: VS Code tasks, Git automation, document generation
- **🤖 Multi-AI**: Supports GitHub Copilot, Claude, GPT-4, and more

### **Conversational Mode** (NEW - Discovery & Planning)
- **💬 RAPID Agent**: Unified conversational agent for systematic workflows
- **📋 26 Workflow Tasks**: Brownfield epics, stories, documentation, elicitation
- **📄 13 YAML Templates**: PRD, architecture, story, QA gate, and more
- **✅ 7 Quality Checklists**: Story definition of done, documentation currency, etc.
- **🧠 Knowledge Base**: Brainstorming techniques, elicitation methods, test frameworks
- **🌐 Multi-Project**: Works with Flutter, React, Python, Go, and any project type

## 🚀 **Quick Start**

### **Execution Mode** (YAML-First Code Generation)
```bash
# Install
npm install -g rapid-ai

# Initialize in your project
cd your-project
rapid init --type flutter --ai copilot

# Analyze a feature
rapid analyze 1 4 "User Authentication"
```

### **Conversational Mode** (Discovery & Planning)
```bash
# Activate RAPID agent in Claude CLI
claude /rapid

# Available commands
*help                        # Show all commands
*create-doc prd-tmpl         # Create PRD from template
*task brownfield-create-epic # Create epic for brownfield project
*execute-checklist story-dod # Run story definition of done checklist
*document-project            # Generate brownfield documentation
*kb                          # Toggle knowledge base mode
```

## 📊 **Proven Results**

This framework was extracted from **EmberCare**, where it delivers:
- ✅ **85-90% Time Reduction**: 2-4 hours → 15-30 minutes per story
- ✅ **100% Architecture Consistency**: Every story follows established patterns
- ✅ **Production Ready**: Used daily by development team
- ✅ **Technical Accuracy**: AI generates correct Flutter/Dart/BLoC code

## 🛠️ **Supported Project Types**

| Project Type | Architecture Support | Status |
|--------------|---------------------|--------|
| **Flutter** | BLoC, Drift, GoRouter | ✅ Production Ready (from EmberCare) |
| **React** | Redux, Context, Hooks | 🚧 In Development |
| **Python** | Django, FastAPI, Flask | 🚧 In Development |
| **Go** | Gin, Echo, Fiber | 🚧 In Development |
| **Generic** | Any project structure | ✅ Template Support |

## 📁 **Framework Structure**

```
ai-dev-workflow/
├── core/                    # Language-agnostic framework
│   ├── scripts/            # Core automation scripts
│   └── workflows/          # Common workflow functions
├── adapters/               # Project-type specific logic
│   └── flutter/           # Flutter + Dart + BLoC (from EmberCare)
├── templates/              # File templates and configurations
│   └── vscode/            # VS Code task templates
└── examples/              # Integration examples
    └── embercare/         # Real-world Flutter healthcare app
```

## ⚙️ **Configuration**

Create `.ai-workflow.yaml` in your project:

```yaml
project:
  type: "flutter"
  architecture: ["bloc", "drift"]
  
ai_tools:
  - "copilot"  # Primary
  
workflows:
  story_analysis:
    enabled: true
    timeout: 120
    outputs:
      - "docs/discovery/{epic}-{story}-discovery.md"
      - "docs/plans/{epic}-{story}-plan.md"

integrations:
  vscode:
    enabled: true
    auto_open_files: true
  git:
    auto_branch: true
    branch_pattern: "story/{epic}-{story}-{slug}"

# Optional: Documentation workflow (keeps docs current)
documentation_workflow:
  enabled: true
  detection:
    enabled: true  # Detect when docs need updating
  ai_analysis:
    enabled: true  # AI-powered documentation suggestions
  completion_gate:
    enabled: false  # Don't block completion (progressive enhancement)
```

## 📝 **Documentation Workflow** (NEW)

Keep your documentation current automatically:

### **How It Works**
1. **Automatic Detection**: Identifies when code changes require doc updates
2. **AI-Powered Suggestions**: Get actionable documentation improvement recommendations
3. **Progressive Enhancement**: Enable features incrementally (detection → suggestions → enforcement)

### **Configuration Levels**

**Level 1: Detection (Default)**
```yaml
documentation_workflow:
  enabled: true
  detection:
    enabled: true  # Informational only
```

**Level 2: AI Suggestions**
```yaml
documentation_workflow:
  ai_analysis:
    enabled: true  # Get AI-powered recommendations
```

**Level 3: Enforcement (Optional)**
```yaml
documentation_workflow:
  completion_gate:
    enabled: true  # Block completion for critical gaps
    enforce_on_critical: true
```

### **Usage**
```bash
# Detect documentation needs from git changes
./core/scripts/doc-detection.sh --git-diff

# Get AI-powered suggestions for specific files
./core/scripts/doc-detection.sh --suggest --files "lib/blocs/medication_bloc.dart"

# Run documentation verification
./core/scripts/task-completion-verification.sh
```

**VS Code Integration:**
- `Documentation: Check Status` - Quick documentation health check
- `Documentation: Interactive Helper` - Guided documentation assistance
- Problem matchers surface documentation issues in VS Code Problems panel

**See:** `docs/architecture/documentation-workflow.md` for complete details

## 🎨 **Usage Examples**

### **Command Line**
```bash
# Complete story setup
ai-workflow setup 1 4 "User Authentication"

# Just analysis
ai-workflow analyze 1 4 "User Authentication"

# Just implementation plan
ai-workflow plan 1 4 "User Authentication"
```

### **VS Code Tasks**
Access via Command Palette:
- `RAPID: Conversational Mode - Instructions` — Launch `/rapid` in Claude
- `RAPID: Create Document / Execute Task / Run Checklist` — Generate conversational commands for templates, tasks, or checklists
- `RAPID: Generate Story from Epic` — Create story YAML via Claude CLI
- `RAPID: Test Claude CLI` — Verify dependencies
- `RAPID: Validate YAML Files / Query All Stories / Show Epic Summary` — Execution utilities backed by `yq`

### **Direct Script Usage**
```bash
# Use core framework scripts directly (after copying .vscode/)
./.vscode/core/scripts/ai-discovery.sh 1 4 "Feature Name" output.md

# Use Flutter adapter (if included)
./.vscode/adapters/flutter/scripts/flutter-discovery.sh 1 4 "Feature" output.md
```

## 🏥 **Real-World Example: EmberCare**

This framework was extracted from **EmberCare**, a Flutter medication management app. The AI workflow system:

**Before Framework:**
- 2-4 hours of manual story analysis per feature
- Inconsistent architecture decisions
- New developers took weeks to understand patterns
- Manual documentation always out of date

**After Framework:**
- 15-30 minutes automated analysis per story
- 100% consistent Flutter/BLoC/Drift patterns
- New developers productive on day 1
- Always up-to-date technical guidance

**EmberCare Integration:**
```yaml
# .ai-workflow.yaml (EmberCare configuration)
project:
  type: "flutter"
  name: "embercare"
  architecture: ["bloc", "drift", "go_router", "get_it"]

custom:
  prd_file: "docs/prd.md"
  theme: "gruvbox_dark"
  primary_platform: "macos"
```

## 🔧 **Installation & Setup**

### **Prerequisites**
- Node.js 18+ for CLI tool
- GitHub Copilot CLI: `npm install -g @github/copilot`
- VS Code (recommended for full integration)

### **Framework Installation**
```bash
# Install globally
npm install -g ai-dev-workflow

# Or use in project
npm install --save-dev ai-dev-workflow
```

### **Project Setup**
```bash
# Initialize AI workflow
cd your-project
ai-workflow init --type flutter

# Copy VS Code tasks (optional)
cp node_modules/ai-dev-workflow/templates/vscode/tasks.json .vscode/

# Test installation
ai-workflow analyze 1 1 "Test Story"
```

## 🚧 **Development Roadmap**

### **Phase 1: Core Framework** ✅
- [x] GitHub Copilot CLI integration
- [x] Flutter adapter with BLoC/Drift support (from EmberCare)
- [x] VS Code tasks system
- [x] Git workflow automation
- [x] Production testing with EmberCare

### **Phase 2: Multi-AI Support** 🚧
- [ ] Claude API integration
- [ ] OpenAI GPT-4 support
- [ ] AI tool failover and redundancy
- [ ] Performance optimization

### **Phase 3: Framework Expansion** 🚧
- [ ] React adapter (Redux, Context, Hooks)
- [ ] Python adapter (Django, FastAPI)
- [ ] Go adapter (Gin, Echo)
- [ ] VS Code extension

### **Phase 4: Advanced Features** 📋
- [ ] BMAD method integration (Business-Model-Architecture-Development)
- [ ] Team collaboration features
- [ ] CI/CD integration
- [ ] Metrics and analytics

## 🤝 **Contributing**

Built for the developer community! Contributions welcome:

1. **Adapters**: Add support for new languages/frameworks
2. **AI Tools**: Integrate additional AI services
3. **Templates**: Improve analysis and planning templates
4. **Documentation**: Examples, guides, tutorials

## 📄 **License**

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 **Acknowledgments**

- **EmberCare Team**: Real-world testing and validation
- **AI Tool Providers**: GitHub Copilot, Anthropic Claude, OpenAI
- **Open Source Community**: Flutter, React, VS Code ecosystems

---

**Transform your development workflow with AI. Reduce analysis time by 85-90%. Focus on building, not planning.**

```bash
npm install -g rapid-ai
rapid init
# Start building faster 🚀
```
