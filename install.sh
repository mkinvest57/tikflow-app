#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}"
echo "╔══════════════════════════════════╗"
echo "║   🤖 TikFlow Installer          ║"
echo "║   TikTok Automation Pipeline    ║"
echo "╚══════════════════════════════════╝"
echo -e "${NC}"

INSTALL_DIR="$HOME/Desktop/tiktokpublish"
TIKFLOW_DIR="$INSTALL_DIR/tiktok-automation"
APP_SOURCE="$(cd "$(dirname "$0")" && pwd)/TikFlow.app"
APP_DEST="/Applications/TikFlow.app"

echo "📦 Installation de TikFlow..."

# 1. Créer le dossier
mkdir -p "$INSTALL_DIR"

# 2. Cloner le code source si pas déjà présent
if [ ! -d "$TIKFLOW_DIR" ]; then
    echo "📥 Téléchargement du code TikFlow..."
    git clone https://github.com/rayanmak/tikflow-app.git "$TIKFLOW_DIR" 2>/dev/null || {
        echo -e "${RED}⚠️  Repo GitHub non accessible.${NC}"
        echo "Assure-toi que le code TikFlow est dans $TIKFLOW_DIR"
        echo "ou clone manuellement : git clone https://github.com/rayanmak/tikflow-app.git $TIKFLOW_DIR"
    }
else
    echo "✅ Code TikFlow déjà présent."
fi

# 3. Setup Python venv
if [ ! -d "$TIKFLOW_DIR/venv" ]; then
    echo "🐍 Création de l'environnement Python..."
    python3 -m venv "$TIKFLOW_DIR/venv"
    "$TIKFLOW_DIR/venv/bin/pip" install --upgrade pip
    "$TIKFLOW_DIR/venv/bin/pip" install flask yt-dlp moviepy requests pillow
    "$TIKFLOW_DIR/venv/bin/pip" install tiktok-uploader
    "$TIKFLOW_DIR/venv/bin/python" -m playwright install chromium
fi

# 4. Copier l'app dans /Applications
echo "📱 Installation de TikFlow.app dans /Applications..."
if [ -d "$APP_DEST" ]; then
    rm -rf "$APP_DEST"
fi
cp -R "$APP_SOURCE" "$APP_DEST"

# 5. Ajouter au login (auto-start)
echo "🚀 Configuration du démarrage automatique..."
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/TikFlow.app", hidden:false}' 2>/dev/null || {
    echo -e "${RED}⚠️  Impossible d'ajouter au démarrage automatique.${NC}"
    echo "Fais-le manuellement : Préférences Système > Général > Ouverture"
}

# 6. Lancer l'app
echo -e "${GREEN}✅ Installation terminée !${NC}"
echo ""
echo -e "${PURPLE}🚀 Lancement de TikFlow...${NC}"
open "$APP_DEST"

echo ""
echo -e "${GREEN}═══ TikFlow est installé ! ═══${NC}"
echo "📊 Dashboard : http://localhost:5050"
echo "📂 Fichiers   : $TIKFLOW_DIR"
echo "🔄 Auto-start : activé au login"
echo ""
echo "Pour désinstaller :"
echo "  rm -rf /Applications/TikFlow.app"
echo "  rm -rf $INSTALL_DIR"
