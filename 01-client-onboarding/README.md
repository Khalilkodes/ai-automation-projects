# Client Onboarding Automation

A local, end-to-end onboarding process for a small bookkeeping firm, built in n8n. All data is invented (example.com addresses, made-up names), and all email is caught by a local test inbox.

## The problem
Staff chase new clients for documents by hand. Reminders get forgotten, nobody can see who is stuck, and there is no record of what happened.

## What it does
1. **Intake:** a client submits a form. The workflow validates the email, rejects duplicates, creates the client record, a document checklist and staff tasks, sends a welcome email, and logs everything.
2. **Reminders:** every day at 09:00 it finds clients still missing documents and sends reminder 1, reminder 2, or alerts staff. Each step happens once, because it is recorded after it is sent.
3. **Document upload:** a client uploads one document at a time. The workflow checks the file and the client, updates the checklist, and marks the client ready when nothing is missing.
4. **Failures:** every rejection is logged, and any workflow error emails staff through a shared error handler.

## Stack
- **n8n** (self-hosted, Docker): the workflows
- **NocoDB:** client, document, task and activity tables
- **Mailpit:** a fake mail server that catches every email, so nothing real is sent
- Everything runs on localhost in Docker.

## Workflows
| File | n8n workflow | Job |
|---|---|---|
| workflows/onboarding-main-intake.json | [Onboarding] Main \| Intake | Form, validation, record creation, welcome email |
| workflows/onboarding-main-reminders.json | [Onboarding] Main \| Reminders | Daily reminders and escalation |
| workflows/onboarding-main-documentupload.json | [Onboarding] Main \| DocumentUpload | Upload form, checklist, ready status |
| ../00-shared/workflows/shared-error-handler.json | [Shared] Error handler | Emails staff when any workflow fails |

Each workflow carries sticky-note documentation on the canvas, and the screenshots show them.

## How it was tested
Tested with invented data: the intake form (valid, invalid email, duplicate, large business), the upload form (wrong file type, unknown client, document not on the checklist, partial and complete uploads), the daily reminders (backdated signup dates to simulate days passing, and a second run to check nothing repeats), and a deliberate failure with the database stopped to confirm the alert email arrives. Test inputs are in `test-data/`.

## Results (demo run)
One new client was followed through the whole process: signup, the three reminder stages (signup date backdated to simulate days passing), then document uploads until ready. All data is invented, and the run was on a local machine.

| Measure | Result |
|---|---|
| Records created automatically | 1 client, 4 document rows, 2 tasks |
| Emails sent with nobody clicking send | 5: welcome, reminder 1, reminder 2, staff escalation alert, staff ready alert |
| Activity log entries for the client | 10: created, welcome email, reminder 1, reminder 2, escalated, four documents received, ready |
| Status progression | awaiting_documents, then escalated, then ready |
| Re-running the daily reminders straight afterwards | Nothing was sent twice |
| Rejections handled and logged | invalid email, duplicate, wrong file type, unknown client, document not on the checklist |
| System failure (database stopped on purpose) | Staff alert email received, naming the failing step |

These numbers are counts from this one run. They show the process works as designed, not how much time it would save a real firm.

## Design decisions
- **Settings live in one place** (a SetConfig node per workflow), not in individual nodes.
- **Steps are recorded after they happen** so reminders never repeat, and the daily job checks what is already done before acting.
- **Searches use "always output data"** so a no-match result still reaches the decision that follows it.
- **Retries are on for searches and updates and off for record creation**, because repeating a create after a timeout could write a duplicate.
- **One shared error handler** serves every project.

## Known limits
- Uploaded files are not stored, and only the file extension is checked.
- Tasks are not marked done automatically when a client becomes ready.
- The welcome email is a template. An AI-written version is a planned extension.
- Mailpit shows the emails are correct but not that they would reach a real inbox.
- Seed data is invented. No time-saved figure is claimed, because nothing was timed against a real firm.

## Run it yourself
See `docker/` for the compose file and `.env.example`. Copy it to `.env`, set the secret (`openssl rand -hex 32`), run `docker compose up -d`, import the CSVs from `test-data/` into NocoDB, and import the workflow JSON files into n8n. You will need to create your own NocoDB token and credentials in n8n.
