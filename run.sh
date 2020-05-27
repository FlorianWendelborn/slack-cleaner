#!/usr/bin/env bash

# TODO: Re-enable after figuring out how to not make the program crash when reaching users you haven’t messaged
# set -euo pipefail

## Load configuration

CHANNELS_TO_DELETE=$(cat channels.txt)
NAMES_TO_DELETE="$(cat names.txt)"

if test -f "./config.sh"; then
	source config.sh
fi

SLACK_TOKEN="${SLACK_TOKEN:-}"
SLACK_USERNAME="${SLACK_USERNAME:-}"
SLACK_CLEANER_DAYS_TO_LEAVE="${SLACK_CLEANER_DAYS_TO_LEAVE:-14}"
SLACK_CLEANER_DELETE_FILES="${SLACK_CLEANER_DELETE_FILES:-false}"
SLACK_CLEANER_SLEEP_BETWEEN="${SLACK_CLEANER_SLEEP_BETWEEN:-5}"

## Sanity-Check

if test -z "$SLACK_TOKEN"; then
	echo "SLACK_TOKEN not provided. Aborting."
	exit 1
fi

if test -z "$SLACK_USERNAME"; then
	echo "SLACK_USERNAME not provided. Aborting."
	exit 2
fi

## Figure out the date

if [[ $OSTYPE == *linux* ]]; then
	DATE=$(date --date=@$(( $(date +%s) - $SLACK_CLEANER_DAYS_TO_LEAVE * 86400 )) +%Y%m%d)
elif [[ $OSTYPE == *darwin* ]]; then
	DATE=$(date -r $(( $(date +%s) - $SLACK_CLEANER_DAYS_TO_LEAVE * 86400 )) +%Y%m%d)
else
	echo "We do not recognise OSTYPE: \"$OSTYPE\""
	exit 3
fi

## Count Names & Channels

COUNT_CHANNELS=$(echo "$CHANNELS_TO_DELETE" | wc -l | xargs)
COUNT_NAMES=$(echo "$NAMES_TO_DELETE" | wc -l | xargs)

## Logging Detected Config

echo "Current Configuration:"
echo ""
echo "---------------------------------"
echo "             SLACK_USERNAME: $SLACK_USERNAME"
echo " SLACK_CLEANER_DELETE_FILES: $SLACK_CLEANER_DELETE_FILES"
echo "SLACK_CLEANER_DAYS_TO_LEAVE: $SLACK_CLEANER_DAYS_TO_LEAVE"
echo "SLACK_CLEANER_SLEEP_BETWEEN: $SLACK_CLEANER_SLEEP_BETWEEN"
echo "---------------------------------"
echo ""
echo "Deleting before \"$DATE\" (YYYYMMDD)"
echo ""
echo "Checking Things to Delete:"
if test -z "$CHANNELS_TO_DELETE"; then echo "[-] Channel messages WILL NOT be deleted because channels.txt is empty"; else echo "[+] Messages in $COUNT_CHANNELS Channels listed in channels.txt WILL be deleted"; fi
if test -z "$NAMES_TO_DELETE"; then echo "[-] Direct messages WILL NOT be deleted as names.txt is empty"; else echo "[+] Direct Messages with $COUNT_NAMES users listed in names.txt WILL be deleted"; fi
if test "$SLACK_CLEANER_DELETE_FILES" != 'true'; then echo "[-] Files WILL NOT be deleted because the configuration prevents this"; else echo "[+] Files WILL be deleted "; fi
echo ""
echo "If you actually want to delete anything, you should pass --perform to this script."
echo "Without --perform, this will only be a dry-run."
echo ""
sleep "$SLACK_CLEANER_SLEEP_BETWEEN"

## Prepare Slack Cleaner

source ./venv/bin/activate
CLEANER="slack-cleaner --token $SLACK_TOKEN --user $SLACK_USERNAME --before $DATE --rate=1 --log"

## Direct Messages

INDEX=1
for NAME in $NAMES_TO_DELETE; do
	sleep "$SLACK_CLEANER_SLEEP_BETWEEN"
	echo "($INDEX/$COUNT_NAMES) Deleting direct messages with $NAME"
	$CLEANER --message --direct "$NAME" $@
	((INDEX++))
done

## Channel Messages

INDEX=1
for CHANNEL in $CHANNELS_TO_DELETE; do
	sleep "$SLACK_CLEANER_SLEEP_BETWEEN"
	echo "($INDEX/$COUNT_CHANNELS) Deleting messages in #$CHANNEL"
	$CLEANER --message --channel "$CHANNEL" $@
	((INDEX++))
done

## Files

if test "$SLACK_CLEANER_DELETE_FILES" == 'true'; then
	sleep "$SLACK_CLEANER_SLEEP_BETWEEN"
	echo "Deleting Files"
	$CLEANER --file $@
fi
