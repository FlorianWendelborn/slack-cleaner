# Slack Cleaner

## Installation

Run `setup.sh`

### Installing `virtualenv` on macOS

```bash
brew install python
pip3 install virtualenv
```

## Configuration

### List of Names

Provide a list of names in `names.txt`:

1. Go to https://yoursubdomain.slack.com/stats#members
2. Select "All Time" and only select the "Username" in "Edit Columns"
3. Remove All columns besides the username (slack-cleaner expects a newline-separated list of usernames)
4. Remove the CSV header if you didn’t do that in step 3
5. Save as `names.txt` in the repo root

### List of Channels

Provide a list of channels in `channels.txt`:

1. TODO

### Slack Username & Token

You can create a `SLACK_TOKEN` here: <https://api.slack.com/custom-integrations/legacy-tokens>

#### Easiest Way (via Config File)

The easiest way is to create a `config.sh` file with the following content:

```bash
SLACK_TOKEN="your-slack-token"
SLACK_USERNAME="your_username"
```

You can also add `SLACK_CLEANER_DAYS_TO_DELETE="14"` to the `config.sh` file if you want to keep less or more than 14 days.

#### Alternative Way (Via Environment)

In case you dislike the idea of a config file, you can also provide the `SLACK_TOKEN`, `SLACK_USERNAME`, and `SLACK_CLEANER_DAYS_TO_DELETE` via environment variables.

## Running

`./run.sh`

Add `--perform` if you actually want to delete the messages it shows. Deleted messages will be saved in `.log` files in the current folder.
