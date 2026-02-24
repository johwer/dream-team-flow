# Name Mapping Reference

This repo uses generic names for project-specific services. Use this table to find-and-replace when adapting to your own project.

## How to customize

Replace the **Generic** names with your own project names:

```bash
# Example: Replace all generic names with your project names
cd shared-claude-files

sed -i '' \
  -e 's/Repo/YourProject/g' \
  -e 's/repo/your-project/g' \
  -e 's/ServiceA/YourServiceA/g' \
  -e 's/service-a/your-service-a/g' \
  -e 's/ServiceB/YourServiceB/g' \
  -e 's/service-b/your-service-b/g' \
  -e 's/ServiceC/YourServiceC/g' \
  -e 's/service-c/your-service-c/g' \
  -e 's/ServiceD/YourServiceD/g' \
  -e 's/service-d/your-service-d/g' \
  -e 's/ServiceE/YourServiceE/g' \
  -e 's/service-e/your-service-e/g' \
  -e 's/TranslationService/YourTranslationService/g' \
  -e 's/TRANSLATION_SERVICE/YOUR_TRANSLATION_SERVICE/g' \
  commands/*.md scripts/*.sh CLAUDE.md
```

## Mapping table

| Generic | Description | Example |
|---------|-------------|---------|
| `Repo` / `repo` | Project/monorepo name | MedHelp, MyApp |
| `ServiceA` / `service-a` | First microservice | Absence, Billing |
| `ServiceB` / `service-b` | Second microservice | HCM, Users |
| `ServiceC` / `service-c` | Auth/identity service | IAM, Auth |
| `ServiceD` / `service-d` | Messaging service | Messenger, Notifications |
| `ServiceE` / `service-e` | Analytics service | Statistics, Analytics |
| `TranslationService` / `TRANSLATION_SERVICE` | i18n/translation platform | Lokalise, Crowdin, Phrase |

## File patterns

These generic names appear in:

- `commands/my-dream-team.md` — agent prompts, Docker commands, API generation
- `commands/create-stories.md` — worktree paths, env file copies
- `commands/workspace-launch.md` — repo paths
- `commands/workspace-cleanup.md` — repo paths
- `scripts/sync-config.sh` — sanitization rules
- `CLAUDE.md` — monorepo section
