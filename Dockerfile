FROM alpine:latest

# Install required packages including AWS CLI
RUN apk add --no-cache bash git curl jq python3 py3-pip aws-cli

# Copy the backup script and make it executable
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Copy environment configuration files
COPY config.env /app/config.env
COPY secrets.env /app/secrets.env

# Set the entrypoint to run the backup script
ENTRYPOINT ["/usr/local/bin/backup.sh"]