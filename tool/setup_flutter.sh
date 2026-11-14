#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.24.5"
CACHE="/home/user/.cache"
SDK="$CACHE/flutter"

mkdir -p "$CACHE"

if [ ! -x "$SDK/bin/flutter" ]; then
  echo "Downloading Flutter $FLUTTER_VERSION …"
  mkdir -p "$CACHE/dl"
  curl -sL -o "$CACHE/dl/flutter.tar.xz" \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
  tar xf "$CACHE/dl/flutter.tar.xz" -C "$CACHE"
  rm -f "$CACHE/dl/flutter.tar.xz"
fi

export PATH="$SDK/bin:$PATH"
export PUB_CACHE="$CACHE/pub"
export HOME=/home/user

flutter config --no-analytics >/dev/null 2>&1 || true
flutter config --enable-web >/dev/null 2>&1 || true

echo "Flutter ready: $(flutter --version | head -1)"
