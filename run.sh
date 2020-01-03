#!/usr/bin/env bash

### CONFIG

# see https://api.slack.com/custom-integrations/legacy-tokens
SLACK_TOKEN="${SLACK_TOKEN:-''}"
SLACK_USERNAME="${SLACK_USERNAME:-''}"
DAYS_TO_LEAVE="${1:-14}"

NAMES_TO_DELETE=$(cat names.txt)

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

#DATE=$(node -p "const d = new Date(Date.now() - $DAYS_TO_LEAVE * 86400000); [d.getFullYear(), d.getMonth() + 1, d.getDate() + 1].join('')")

# macbros: run `rew install coreutils`
DATE=$(date --date="@$(($(date +%s) - $DAYS_TO_LEAVE * 86400))" +%Y%m%d)

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
