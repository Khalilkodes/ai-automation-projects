# Workflows

Exported from n8n and importable through the n8n menu. Credentials are not included, so create your own NocoDB and SMTP credentials after importing.

| File | Purpose |
|---|---|
| onboarding-main-intake.json | Intake form, validation, duplicate check, record creation, welcome email |
| onboarding-main-reminders.json | Daily reminders and escalation. Keep it inactive until you are ready to send |
| onboarding-main-documentupload.json | Upload form, checklist update, ready status |

The shared error handler is in 00-shared/workflows.
