#!/usr/bin/env bash

### CONFIG

# see https://api.slack.com/custom-integrations/legacy-tokens
SLACK_TOKEN=""
SLACK_USERNAME=""
DAYS_TO_LEAVE="14"

NAMES_TO_DELETE=$(cat names.txt)
CHANNELS_TO_DELETE=$(cat channels.txt)

if test -z "$SLACK_TOKEN"; then
	echo "SLACK_TOKEN not provided. Aborting."
	exit 1
fi

if test -z "$SLACK_USERNAME"; then
	echo "SLACK_USERNAME not provided. Aborting."
	exit 1
fi

if test -z "NAMES_TO_DELETE"; then
	echo "names.txt is empty. Nothing to do here."
	exit 0
fi

### SCRIPT

DATE=$(node -p "const d = new Date(Date.now() - $DAYS_TO_LEAVE * 86400000); [d.getFullYear(), d.getMonth() + 1, d.getDate() + 1].join('')")

source ./venv/bin/activate
echo "add --perform to actually do the thing"

for NAME in $NAMES_TO_DELETE; do
	sleep 5
	echo "Deleting direct messages with $NAME"
	slack-cleaner --token "$SLACK_TOKEN" --rate=1 --message --direct "$NAME" --user "$SLACK_USERNAME" --before "$DATE" --log $@
done;

for CHANNEL in $CHANNELS_TO_DELETE; do
	sleep 5
	echo "Deleting messages in #$CHANNEL"
	slack-cleaner --token "$SLACK_TOKEN" --rate=1 --message --channel "$CHANNEL" --user "$SLACK_USERNAME" --before "$DATE" --log $@
done;
