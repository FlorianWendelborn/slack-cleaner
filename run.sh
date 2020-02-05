#!/usr/bin/env bash

# TODO: Re-enable after figuring out how to not make the program crash when reaching users you haven’t messaged
# set -euo pipefail

# Load configuration

CHANNELS_TO_DELETE=$(cat channels.txt)
NAMES_TO_DELETE="$(cat names.txt)"

if test -f "./config.sh"; then
	source config.sh
fi

SLACK_TOKEN="${SLACK_TOKEN:-}"
SLACK_USERNAME="${SLACK_USERNAME:-}"
SLACK_CLEANER_DAYS_TO_LEAVE="${SLACK_CLEANER_DAYS_TO_LEAVE:-14}"

if test -z "$SLACK_TOKEN"; then
	echo "SLACK_TOKEN not provided. Aborting."
	exit 1
fi

if test -z "$SLACK_USERNAME"; then
	echo "SLACK_USERNAME not provided. Aborting."
	exit 2
fi

if test -z "$NAMES_TO_DELETE"; then
	if test -z "$CHANNELS_TO_DELETE"; then
		echo "names.txt and channels.txt are empty. Nothing to do here."
		exit 0
	fi
fi

# Figure out the date

if [[ $OSTYPE == *linux* ]]; then
	DATE=$(date --date=@$(( $(date +%s) - $SLACK_CLEANER_DAYS_TO_LEAVE * 86400 )) +%Y%m%d)
elif [[ $OSTYPE == *darwin* ]]; then
	DATE=$(date -r $(( $(date +%s) - $SLACK_CLEANER_DAYS_TO_LEAVE * 86400 )) +%Y%m%d)
else
	echo "We do not recognise OSTYPE: \"$OSTYPE\""
	exit 3
fi

# Execute

source ./venv/bin/activate
echo "add --perform to actually do the thing"

for NAME in $NAMES_TO_DELETE; do
	sleep 5
	echo "Deleting direct messages with $NAME"
	slack-cleaner \
		--token "$SLACK_TOKEN" \
		--rate=1 \
		--message \
		--direct "$NAME" \
		--user "$SLACK_USERNAME" \
		--before "$DATE" \
		--log $@
done

for CHANNEL in $CHANNELS_TO_DELETE; do
	sleep 5
	echo "Deleting messages in #$CHANNEL"
	slack-cleaner \
		--token "$SLACK_TOKEN" \
		--rate=1 \
		--message \
		--channel "$CHANNEL" \
		--user "$SLACK_USERNAME" \
		--before "$DATE" \
		--log $@
done
