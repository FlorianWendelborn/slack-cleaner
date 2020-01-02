# Slack Cleaner

## Installation

Run `setup.sh`

## Configuration

Provide a list of names in `names.txt`:

### List of Names

1. Go to https://yoursubdomain.slack.com/stats#members
2. Select "All Time" and only select the "Username" in "Edit Columns"
3. Remove All columns besides the username (slack-cleaner expects a newline-separated list of usernames)
4. Remove the CSV header if you didn’t do that in step 3
5. Save as `names.txt` in the repo root

### Slack Token, etc.

See https://api.slack.com/custom-integrations/legacy-tokens

Insert your `SLACK_TOKEN`, and `SLACK_USERNAME` in `run.sh`. Consider adjusting the `DAYS_TO_DELETE`.

## Running

`./run.sh`

Add `--perform` if you actually want to delete the messages it shows.
