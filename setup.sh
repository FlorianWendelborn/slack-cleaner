#!/usr/bin/env bash

set -euo pipefail

virtualenv venv --python=python2.7
source ./venv/bin/activate
pip install slack-cleaner
