# RAPID-AI Changelog

All notable changes to this project will be documented in this file.

**Update Policy:** This changelog is updated **only when PRs are merged to main branch**.

## [Unreleased]

### Work in Progress - Architecture Restructuring (Phases 1-6)

Current status: Phase 4 complete (2025-10-24)

**Completed:**
- Phase 1 (2025-10-24): Created src/dist structure + build infrastructure
- Phase 2 (2025-10-24): Extracted BMAD → src/rapid/ (26 tasks, 13 templates, 7 checklists, 1 unified agent)
- Phase 3 (2025-10-24): Built distribution system (build-dist.sh, install-to-project.sh, VS Code tasks)
- Phase 4 (2025-10-24): Deleted legacy .bmad-* directories, removed BMAD branding from package.json

**In Progress:**
- Phase 5: Documentation updates (dual-mode framework, architecture guide)
- Phase 6: Testing (RAPID-AI self-test, EmberCare distribution validation)

**Detailed Planning:** See `docs/planning/rapid-ai-restructuring-implementation-plan.yaml` for complete implementation tracking, phase details, and lessons learned.

---

## How to Use This Changelog

- **This file**: High-level changelog updated only on PR merge to main
- **Planning file**: `docs/planning/rapid-ai-restructuring-implementation-plan.yaml` - detailed implementation tracking with all phase completion details
- **Workflow**: Work documented in planning YAML → PR merged to main → Summary added here

---

## Future Releases

When the restructuring is complete and merged to main, this file will be updated with:

```markdown
## [2.0.0] - YYYY-MM-DD

### Added
- Unified src/dist architecture with clean separation
- RAPID conversational framework (extracted from BMAD)
- Build and distribution system (build-dist.sh, install-to-project.sh)
- VS Code tasks for both conversational and execution modes

### Changed
- Migrated from BMAD branding to RAPID-AI
- Consolidated 10 agents into 1 unified rapid-master.md
- Updated all templates, tasks, and checklists to RAPID format

### Removed
- Legacy .bmad-core/ and .bmad-infrastructure-devops/ directories
- BMAD branding from package.json
- One-time migration helper scripts
```

---

**Version History:** When versions are released, they will be documented above with dates and semantic versioning.
