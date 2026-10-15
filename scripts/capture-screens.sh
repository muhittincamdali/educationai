#!/usr/bin/env bash
# Captures the README screenshots of the StudyDeck example app on an iPhone simulator.
#
# The script builds and installs the app and launches it with `-demo`, which loads three weeks
# of simulated study ending at 09:41 on 15 October 2026 (seeded, so every run shows the same
# cards and numbers), plus launch arguments that open one screen. It takes a simulator
# screenshot of each screen in light and dark appearance.
#
# Usage: scripts/capture-screens.sh [simulator name or UDID]
# Without an argument it uses a simulator named "iPhone 17 Pro".
# Output: docs/images/<screen>-light.png and docs/images/<screen>-dark.png for the screens
# review, quiz, progress and deck, each scaled to half the simulator's width.
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
device="${1:-iPhone 17 Pro}"
bundle_id="io.github.muhittincamdali.StudyDeck"
output_dir="$repo_root/docs/images"
build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT
mkdir -p "$output_dir"

destination="platform=iOS Simulator,name=$device"
if [[ "$device" =~ ^[0-9A-F-]{36}$ ]]; then
  destination="platform=iOS Simulator,id=$device"
fi
echo "Building StudyDeck for '$device'"
xcodebuild build \
  -project "$repo_root/Examples/StudyDeck/StudyDeck.xcodeproj" \
  -scheme StudyDeck \
  -destination "$destination" \
  -derivedDataPath "$build_dir" \
  -quiet
app="$(find "$build_dir/Build/Products" -maxdepth 2 -name 'StudyDeck.app' -path '*iphonesimulator*' | head -1)"

xcrun simctl boot "$device" 2>/dev/null || true
xcrun simctl bootstatus "$device" -b >/dev/null
xcrun simctl install "$device" "$app"
# A fixed clock and full bars keep the status bar the same in every image.
xcrun simctl status_bar "$device" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularBars 4 --wifiBars 3 >/dev/null

# The first launch after an install is slow; launch once before taking any screenshot.
xcrun simctl launch --terminate-running-process "$device" "$bundle_id" -demo >/dev/null
sleep 5

capture() {
  local name="$1"
  shift
  for appearance in light dark; do
    xcrun simctl ui "$device" appearance "$appearance"
    # English text and number formats, whatever the region the simulator inherited from the Mac.
    xcrun simctl launch --terminate-running-process "$device" "$bundle_id" -demo "$@" \
      -AppleLanguages "(en)" -AppleLocale en_US >/dev/null
    sleep 4
    local file="$output_dir/$name-$appearance.png"
    xcrun simctl io "$device" screenshot --type=png "$file" >/dev/null 2>&1
    sips --resampleWidth "$(( $(sips -g pixelWidth "$file" | awk '/pixelWidth/ {print $2}') / 2 ))" "$file" >/dev/null
    echo "$file"
  done
}

capture review -tab review -show-answer
capture quiz -tab quiz -quiz-typo
capture progress -tab progress
capture deck -tab deck

xcrun simctl status_bar "$device" clear
