#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -e
set -o pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/../../.." && pwd )"

cd "$PROJECT_DIR"

./go version:bump[pre]

bundle install
LAST_MESSAGE="$(git log -1 --pretty=%B)"
git commit -a --amend -m "${LAST_MESSAGE} [ci skip]"

./go release

git status
git push
