#!/usr/bin/env bash
set -euo pipefail

operation="${1:-switch}"
confirmation="${2:-yes}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "Extracting substituters from flake..."

# Extract all substituters from flake
SUBSTITUTERS_JSON=$(nix eval .#substituters --json)

# Parse into space-separated lists
URLS=$(echo "$SUBSTITUTERS_JSON" | jq -r '.[] | .[].url' | tr '\n' ' ')
KEYS=$(echo "$SUBSTITUTERS_JSON" | jq -r '.[] | .[].key' | tr '\n' ' ')

echo "Found $(echo "$SUBSTITUTERS_JSON" | jq 'to_entries | length') cache groups:"
echo "$SUBSTITUTERS_JSON" | jq -r 'to_entries[] | "  • \(.key): \(.value[0].url)"'
echo

if [[ "$confirmation" == "yes" ]]; then
	gum confirm "Rebuild with these substituters?" || exit 0
fi

echo "Rebuilding with extracted substituters..."

nh os "$operation" "$(realpath /etc/nixos)" --ask -- \
	--option extra-substituters "$URLS" \
	--option extra-trusted-public-keys "$KEYS"
