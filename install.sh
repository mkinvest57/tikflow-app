#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo ""
echo "╔══════════════════════════════════╗"
echo "║   🤖 TikFlow Installer v3       ║"
echo "║   TikTok Automation Pipeline    ║"
echo "╚══════════════════════════════════╝"
echo ""

INSTALL_DIR="$HOME/Desktop/tiktokpublish"
TIKFLOW_DIR="$INSTALL_DIR/tiktok-automation"
APP_SOURCE="$(cd "$(dirname "$0")" && pwd)/TikFlow.app"
APP_DEST="/Applications/TikFlow.app"

echo "📦 Installation de TikFlow v3..."

# 1. Créer le dossier
mkdir -p "$INSTALL_DIR"

# 2. Cloner le code source
if [ ! -d "$TIKFLOW_DIR" ]; then
    echo "📥 Téléchargement du code TikFlow..."
    git clone https://github.com/mkinvest57/tikflow.git "$TIKFLOW_DIR" 2>/dev/null || {
        echo -e "${RED}⚠️  Repo GitHub non accessible. Essaie :${NC}"
        echo "   git clone https://github.com/mkinvest57/tikflow.git $TIKFLOW_DIR"
        exit 1
    }
else
    echo "✅ Code TikFlow déjà présent, mise à jour..."
    cd "$TIKFLOW_DIR" && git pull 2>/dev/null || true
fi

# 3. Setup Python venv
if [ ! -d "$TIKFLOW_DIR/venv" ]; then
    echo "🐍 Création de l'environnement Python..."
    python3 -m venv "$TIKFLOW_DIR/venv"
fi
echo "📦 Installation des dépendances Python..."
"$TIKFLOW_DIR/venv/bin/pip" install --upgrade pip -q
"$TIKFLOW_DIR/venv/bin/pip" install flask yt-dlp moviepy requests pillow python-dotenv -q
"$TIKFLOW_DIR/venv/bin/pip" install tiktok-uploader -q
echo "🎭 Installation de Chromium (Playwright)..."
"$TIKFLOW_DIR/venv/bin/python" -m playwright install chromium 2>/dev/null || true

# 4. Copier l'app dans /Applications
echo "📱 Installation de TikFlow.app dans /Applications..."
if [ -d "$APP_DEST" ]; then
    rm -rf "$APP_DEST"
fi
cp -R "$APP_SOURCE" "$APP_DEST"

# 5. Ajouter au login
echo "🚀 Configuration du démarrage automatique..."
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/TikFlow.app", hidden:false}' 2>/dev/null || {
    echo -e "${RED}⚠️  Ajout au démarrage manuel nécessaire.${NC}"
}

echo ""
echo -e "${GREEN}✅ TikFlow v3 installé !${NC}"
echo ""
echo "📊 Dashboard : http://localhost:5050"
echo "📂 Code       : $TIKFLOW_DIR"
echo "🔄 Auto-start : activé au login"
echo ""
echo "Pour lancer : ouvre TikFlow depuis /Applications"
echo "Pour désinstaller :"
echo "  rm -rf /Applications/TikFlow.app ~/Desktop/tiktokpublish"
