#!/usr/bin/env bash
# Given a plugin URL adds the plugin as a git submodule
#
set -euo pipefail

url=$1
arrIN=(${url//\// })
repo=${arrIN[3]}
arrRepo=(${repo//.git/ })
name=${arrRepo[0]}
git submodule add $url ./plugins/start/$name
