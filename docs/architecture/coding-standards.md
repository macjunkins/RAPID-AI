# Coding Standards

## Shell Script Standards
- POSIX-compatible bash for maximum environment compatibility
- Environment detection handles VS Code, Codespaces, terminal differences
- Timeout protection prevents hanging on AI calls
- All core logic in shell scripts for portability

## Node.js CLI Standards
- TypeScript for type safety
- Commander for CLI structure
- Inquirer for interactive prompts
- Chalk for colored output

## Project Structure Standards
- Three-layer architecture: Core → Adapters → Templates
- VS Code tasks as primary interface
- Shell scripts for core functionality
- Node.js CLI as optional secondary interface
