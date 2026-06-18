#!/bin/bash
set -e

# ═══════════════════════════════════════════════
# TikFlow — One-liner installer
# curl -fsSL https://raw.githubusercontent.com/mkinvest57/tikflow-app/main/install.sh | bash
# ═══════════════════════════════════════════════

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo ""
echo "╔══════════════════════════════════╗"
echo "║   🤖 TikFlow v3 — Installer     ║"
echo "╚══════════════════════════════════╝"
echo ""

INSTALL_DIR="$HOME/Desktop/tiktokpublish"
TIKFLOW_DIR="$INSTALL_DIR/tiktok-automation"

# ── 1. Homebrew ──
if ! command -v brew &>/dev/null; then
    echo "🍺 Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
fi

# ── 2. Python 3.11+ ──
PYTHON_OK=false
for cmd in python3.14 python3.13 python3.12 python3.11 python3; do
    if command -v "$cmd" &>/dev/null; then
        v=$("$cmd" -c 'import sys; print(sys.version_info[:2])' 2>/dev/null || echo "(0,0)")
        major=$(echo "$v" | grep -oE '[0-9]+' | head -1)
        minor=$(echo "$v" | grep -oE '[0-9]+' | tail -1)
        if [ "$major" -ge 3 ] && [ "$minor" -ge 11 ] 2>/dev/null; then
            PYTHON_CMD="$cmd"
            PYTHON_OK=true
            echo "🐍 Python $major.$minor détecté ($cmd)"
            break
        fi
    fi
done
if ! $PYTHON_OK; then
    echo "🐍 Installation de Python 3.12 via Homebrew..."
    brew install python@3.12
    PYTHON_CMD="python3.12"
fi

# ── 3. FFmpeg + ImageMagick ──
for pkg in ffmpeg imagemagick; do
    if ! command -v "$pkg" &>/dev/null; then
        echo "📦 Installation de $pkg..."
        brew install "$pkg"
    else
        echo "✅ $pkg déjà installé"
    fi
done

# ── 4. Code TikFlow ──
mkdir -p "$INSTALL_DIR"
if [ ! -d "$TIKFLOW_DIR" ]; then
    echo "📥 Clonage du code TikFlow..."
    git clone https://github.com/mkinvest57/tikflow.git "$TIKFLOW_DIR"
else
    echo "✅ Code déjà présent, mise à jour..."
    cd "$TIKFLOW_DIR" && git pull 2>/dev/null || true
fi

# ── 5. Python venv + dépendances ──
if [ ! -d "$TIKFLOW_DIR/venv" ]; then
    echo "🐍 Création de l'environnement virtuel..."
    "$PYTHON_CMD" -m venv "$TIKFLOW_DIR/venv"
fi
echo "📦 Installation des dépendances Python..."
"$TIKFLOW_DIR/venv/bin/pip" install --upgrade pip -q 2>/dev/null
"$TIKFLOW_DIR/venv/bin/pip" install flask yt-dlp moviepy requests pillow python-dotenv -q 2>/dev/null
echo "🎭 Installation de Chromium (Playwright)..."
"$TIKFLOW_DIR/venv/bin/pip" install playwright -q 2>/dev/null
"$TIKFLOW_DIR/venv/bin/python" -m playwright install chromium 2>/dev/null || echo "   ⚠️ Chromium non installé (Playwright fonctionnera sans)"

# ── 6. App dans /Applications ──
APP_DEST="/Applications/TikFlow.app"
if [ -d "$APP_DEST" ]; then
    rm -rf "$APP_DEST"
fi
# Si lancé depuis le DMG, copier l'app
DMG_APP="$(cd "$(dirname "$0")" 2>/dev/null && pwd)/TikFlow.app"
if [ -d "$DMG_APP" ]; then
    cp -R "$DMG_APP" "$APP_DEST"
else
    # Sinon, créer une app minimale
    mkdir -p "$APP_DEST/Contents/MacOS"
    cat > "$APP_DEST/Contents/MacOS/TikFlow" << 'APPEOF'
#!/bin/bash
TIKFLOW_DIR="$HOME/Desktop/tiktokpublish/tiktok-automation"
lsof -ti:5050 | xargs kill -9 2>/dev/null || true
cd "$TIKFLOW_DIR"
"$TIKFLOW_DIR/venv/bin/python" app.py > /tmp/tikflow.log 2>&1 &
for i in $(seq 1 20); do curl -s http://localhost:5050/api/system/status >/dev/null 2>&1 && break; sleep 0.5; done
open http://localhost:5050
wait
APPEOF
    chmod +x "$APP_DEST/Contents/MacOS/TikFlow"
fi

# ── 7. Login item ──
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/TikFlow.app", hidden:false}' 2>/dev/null || true

# ── 8. Lancement ──
echo ""
echo -e "${GREEN}✅ TikFlow v3 installé !${NC}"
echo ""
echo "📊 Dashboard : http://localhost:5050"
echo "📂 Code       : $TIKFLOW_DIR"
echo "🔄 Auto-start : activé au login"
echo ""
echo -e "${YELLOW}🚀 Lancement de TikFlow...${NC}"
open "$APP_DEST" 2>/dev/null || open http://localhost:5050
echo ""
