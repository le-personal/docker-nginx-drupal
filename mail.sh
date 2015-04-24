#!/bin/bash

cat > /etc/msmtprc <<EOF
# Default settings that all others account inherit 
defaults 
port $SMTP_PORT
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt 

# Or to log to log own file
logfile  /var/log/supervisor/msmtp.log 

keepbcc  on

# Default account to use 

# Gmail/Google Apps (configure as may as you want)
account  gmail 
auth on
host $SMTP_HOST
from $SMTP_FROMNAME
user $SMTP_USERNAME
password $SMTP_PASSWORD

account default : gmail
EOF




