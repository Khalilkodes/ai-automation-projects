# Test data

All data is invented (example.com addresses, made-up names).

| File | What it is |
|---|---|
| clients.csv, documents.csv, tasks.csv, activity_log.csv | Seed rows to import into the matching NocoDB tables. Six clients, each in a different stage so every reminder rule gets exercised |
| generate-mock-data.sh | Regenerates the four CSVs with dates relative to today, because the reminder logic depends on how old each signup is |
| test-cases.csv | Inputs for the intake form: happy path, duplicate email, invalid email, large business |
| not-a-document.txt | A file with the wrong type, for testing the upload rejection |
| sample-uploads/ | Placeholder PDFs for testing the upload form (only the file extension is checked) |
