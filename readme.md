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

1. Go to https://yoursubdomain.slack.com/stats#channels
2. Select "All Time" and deselect everyhing in "Edit Columns"
3. Remove All Columns besides the channel name (`slack-cleaner` expects a newline-separated list of usernames)
4. Remove the CSV header if you didn’t do that in step 3
5. Save as `channels.txt` in the repo root

### Slack Username & Token

You can create a `SLACK_TOKEN` here: <https://api.slack.com/custom-integrations/legacy-tokens>

### Configuring via Config File

The easiest way to configure `slack-cleaner` is to create a `config.sh` file with the following content:

```bash
SLACK_TOKEN="your-slack-token"
SLACK_USERNAME="your_username"
```

You can also add `SLACK_CLEANER_DAYS_TO_LEAVE="14"` to the `config.sh` file if you want to keep less or more than the default of the last 14 days.

If you want to clean files, you can also add this:

```bash
SLACK_CLEANER_DELETE_FILES="true"
```

### Configuration Options

Configuration options can be provided via the environment or added to `config.sh`.

|                          Name | Description                         | Default | Required |
| ----------------------------: | :---------------------------------- | :------ | :------- |
|                 `SLACK_TOKEN` | Your Slack Legacy Token             | —       | ✅       |
|              `SLACK_USERNAME` | Your Slack Username                 | —       | ✅       |
| `SLACK_CLEANER_DAYS_TO_LEAVE` | Amount of recent days to keep       | `14`    | ❌       |
|  `SLACK_CLEANER_DELETE_FILES` | Should files be deleted?            | `false` | ❌       |
| `SLACK_CLEANER_SLEEP_BETWEEN` | Adjust to prevent API Rate Limiting | `5`     | ❌       |

**`channels.txt`**: Channels to delete messages in  
**`names.txt`**: Usernames to delete direct messages with

## Running

`./run.sh`

Add `--perform` if you actually want to delete the messages it shows. Deleted messages will be saved in `.log` files in the current folder.
