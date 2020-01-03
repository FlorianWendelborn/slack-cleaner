#!/usr/bin/env bash

### CONFIG

# see https://api.slack.com/custom-integrations/legacy-tokens
SLACK_TOKEN="${SLACK_TOKEN:-}"
SLACK_USERNAME="${SLACK_USERNAME:-}"
DAYS_TO_LEAVE="${1:-14}"
NAMES_TO_DELETE="$(cat names.txt)"

shift

if test -z "$SLACK_TOKEN"; then
	echo "SLACK_TOKEN not provided. Aborting."
	exit 1
fi

if test -z "$SLACK_USERNAME"; then
	echo "SLACK_USERNAME not provided. Aborting."
	exit 2
fi

if test -z "$NAMES_TO_DELETE"; then
	echo "names.txt is empty. Nothing to do here."
	exit 0
fi

### SCRIPT


if [[ $OSTYPE == *linux* ]]; then
	DATE=$(date --date=@$(( $(date +%s) - $DAYS_TO_LEAVE * 86400 )) +%Y%m%d)
elif [[ $OSTYPE == *darwin* ]]; then
	DATE=$(date -r $(( $(date +%s) - $DAYS_TO_LEAVE * 86400 )) +%Y%m%d)
else
	echo "We do not recognise OSTYPE: $OSTYPE"
	exit 3
fi

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
