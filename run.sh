#!/usr/bin/env bash

### CONFIG

# see https://api.slack.com/custom-integrations/legacy-tokens
SLACK_TOKEN="${SLACK_TOKEN:-''}"
SLACK_USERNAME="${SLACK_USERNAME:-''}"
DAYS_TO_LEAVE="${1:-14}"
NAMES_TO_DELETE="$(cat names.txt)"
DATEUTIL="$(which gdate || which date)"

if test -z "$SLACK_TOKEN"; then
	echo "SLACK_TOKEN not provided. Aborting."
	exit 1
fi

if test -z "$SLACK_USERNAME"; then
	echo "SLACK_USERNAME not provided. Aborting."
	exit 1
fi

if test -z "$NAMES_TO_DELETE"; then
	echo "names.txt is empty. Nothing to do here."
	exit 0
fi

### SCRIPT

# macbros: run `brew install coreutils` and use `gdate`
DATE=$(
	$DATEUTIL \
		--date=@$(($($DATEUTIL +%s) - $DAYS_TO_LEAVE * 86400)) \
		+%Y%m%d
)

source ./venv/bin/activate
echo "add --perform to actually do the thing"

for NAME in $NAMES_TO_DELETE; do
	slack-cleaner \
		--token "$SLACK_TOKEN" \
		--rate=1 --message \
		--direct "$NAME" \
		--user "$SLACK_USERNAME" \
		--before "$DATE" --log $@
done
