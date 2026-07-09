# Skills

Personal agent skills library, compatible with the [agentskills.io](https://agentskills.io) specification.

## Structure

```
skills/
├── <skill-name>/
│   ├── SKILL.md           # Required: metadata + instructions
│   ├── scripts/           # Optional: executable code
│   ├── references/        # Optional: documentation loaded on demand
│   └── assets/            # Optional: templates, resources
└── ...
```

## Installation

### Claude Code (per-project)

```bash
# Symlink a skill into your project
ln -s /path/to/this/repo/<skill-name> .claude/skills/<skill-name>
```

### Claude Code (global)

```bash
ln -s /path/to/this/repo/<skill-name> ~/.claude/skills/<skill-name>
```

### Kiro (via steering file)

Reference a skill from a `.kiro/steering/*.md` file:

```markdown
Read `skills/<skill-name>/SKILL.md` for instructions on this task.
```

### Other agents

Any agent supporting agentskills.io can discover skills by scanning this directory for `SKILL.md` files.

## Creating a new skill

```bash
mkdir <skill-name>
cat > <skill-name>/SKILL.md << 'EOF'
---
name: skill-name
description: What this skill does and when to use it.
---

# Skill Name

Instructions go here.
EOF
```

### Frontmatter spec

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | Max 64 chars, kebab-case, must match directory name |
| `description` | Yes | Max 1024 chars, describes what + when to use |
| `license` | No | License name or reference |
| `compatibility` | No | Max 500 chars, environment requirements |
| `metadata` | No | Arbitrary key-value pairs |

## License

This project is licensed under the [MIT License](LICENSE).
