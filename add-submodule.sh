#!/usr/bin/env bash
# Given a plugin URL adds the plugin as a git submodule
# Usage:
#   add-submodule.sh <repo-url>
# Example:
#   add-submodule.sh https://github.com/Equilibris/nx.nvim.git
#
set -euo pipefail

url=$1
arrIN=(${url//\// })
repo=${arrIN[3]}
arrRepo=(${repo//.git/ })
name=${arrRepo[0]}
git submodule add $url ./plugins/start/$name
