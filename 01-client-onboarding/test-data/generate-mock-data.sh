#!/usr/bin/env bash
# Generates the dated mock CSVs. Usage: ./generate-mock-data.sh [output-dir]
# Dates are relative to today, so the reminder logic can always be tested.
set -euo pipefail
OUT="${1:-.}"
mkdir -p "$OUT"
cd "$OUT"

ago()   { date -d "$1 days ago" "+%Y-%m-%d %H:%M:%S"; }
agod()  { date -d "$1 days ago" "+%Y-%m-%d"; }
ahead() { date -d "$1 days" "+%Y-%m-%d"; }

cat > clients.csv << EOF
full_name,email,business_name,business_type,status,created_at,reminder_1_sent_at,reminder_2_sent_at,escalated_at
Amara Colley,amara.colley@example.com,Colley Fresh Produce,retail,ready,$(ago 12),$(ago 10),,
Lamin Jallow,lamin.jallow@example.com,Jallow Auto Parts,retail,awaiting_documents,$(ago 3),,,
Fatou Ceesay,fatou.ceesay@example.com,Ceesay Tailoring,services,awaiting_documents,$(ago 6),$(ago 4),,
Ousman Bojang,ousman.bojang@example.com,Bojang Hardware,retail,awaiting_documents,$(ago 9),$(ago 7),$(ago 4),
Isatou Njie,isatou.njie@example.com,Njie Catering,hospitality,escalated,$(ago 15),$(ago 13),$(ago 10),$(ago 8)
Modou Sanneh,modou.sanneh@example.com,Sanneh Transport,transport,awaiting_documents,$(ago 0),,,
EOF

cat > documents.csv << EOF
client_email,doc_type,status,received_at
amara.colley@example.com,id_document,received,$(ago 11)
amara.colley@example.com,business_registration,received,$(ago 11)
amara.colley@example.com,bank_statements,received,$(ago 10)
amara.colley@example.com,tax_records,received,$(ago 10)
lamin.jallow@example.com,id_document,pending,
lamin.jallow@example.com,business_registration,pending,
lamin.jallow@example.com,bank_statements,pending,
lamin.jallow@example.com,tax_records,pending,
fatou.ceesay@example.com,id_document,received,$(ago 5)
fatou.ceesay@example.com,business_registration,pending,
fatou.ceesay@example.com,bank_statements,pending,
fatou.ceesay@example.com,tax_records,pending,
ousman.bojang@example.com,id_document,received,$(ago 8)
ousman.bojang@example.com,business_registration,received,$(ago 8)
ousman.bojang@example.com,bank_statements,pending,
ousman.bojang@example.com,tax_records,pending,
isatou.njie@example.com,id_document,pending,
isatou.njie@example.com,business_registration,pending,
isatou.njie@example.com,bank_statements,pending,
isatou.njie@example.com,tax_records,pending,
modou.sanneh@example.com,id_document,pending,
modou.sanneh@example.com,business_registration,pending,
modou.sanneh@example.com,bank_statements,pending,
modou.sanneh@example.com,tax_records,pending,
EOF

cat > tasks.csv << EOF
client_email,task,owner,due_date,done
amara.colley@example.com,Collect documents,Binta,$(agod 10),true
amara.colley@example.com,Schedule kickoff call,Ebrima,$(agod 8),true
lamin.jallow@example.com,Collect documents,Binta,$(ahead 4),false
lamin.jallow@example.com,Schedule kickoff call,Ebrima,$(ahead 9),false
fatou.ceesay@example.com,Collect documents,Binta,$(ahead 1),false
fatou.ceesay@example.com,Schedule kickoff call,Ebrima,$(ahead 6),false
ousman.bojang@example.com,Collect documents,Binta,$(agod 1),false
ousman.bojang@example.com,Schedule kickoff call,Ebrima,$(ahead 4),false
isatou.njie@example.com,Collect documents,Binta,$(agod 3),false
isatou.njie@example.com,Schedule kickoff call,Ebrima,$(ahead 2),false
modou.sanneh@example.com,Collect documents,Binta,$(ahead 7),false
modou.sanneh@example.com,Schedule kickoff call,Ebrima,$(ahead 12),false
EOF

cat > activity_log.csv << EOF
client_email,event,details,timestamp
amara.colley@example.com,client_created,intake form received,$(ago 12)
amara.colley@example.com,welcome_email_sent,welcome email sent,$(ago 12)
amara.colley@example.com,reminder_1_sent,first reminder sent,$(ago 10)
amara.colley@example.com,client_ready,all documents received,$(ago 10)
lamin.jallow@example.com,client_created,intake form received,$(ago 3)
lamin.jallow@example.com,welcome_email_sent,welcome email sent,$(ago 3)
fatou.ceesay@example.com,client_created,intake form received,$(ago 6)
fatou.ceesay@example.com,welcome_email_sent,welcome email sent,$(ago 6)
fatou.ceesay@example.com,reminder_1_sent,first reminder sent,$(ago 4)
ousman.bojang@example.com,client_created,intake form received,$(ago 9)
ousman.bojang@example.com,welcome_email_sent,welcome email sent,$(ago 9)
ousman.bojang@example.com,reminder_1_sent,first reminder sent,$(ago 7)
ousman.bojang@example.com,reminder_2_sent,second reminder sent,$(ago 4)
isatou.njie@example.com,client_created,intake form received,$(ago 15)
isatou.njie@example.com,welcome_email_sent,welcome email sent,$(ago 15)
isatou.njie@example.com,reminder_1_sent,first reminder sent,$(ago 13)
isatou.njie@example.com,reminder_2_sent,second reminder sent,$(ago 10)
isatou.njie@example.com,escalated,staff alerted after no response,$(ago 8)
modou.sanneh@example.com,client_created,intake form received,$(ago 0)
modou.sanneh@example.com,welcome_email_sent,welcome email sent,$(ago 0)
EOF

echo "Generated dated CSVs in: $(pwd)"
