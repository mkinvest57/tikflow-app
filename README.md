# 🤖 TikFlow — TikTok Automation Pipeline

**Un pipeline TikTok 100% automatisé pour macOS.**  
TikFlow scanne des chaînes YouTube, extrait les meilleurs moments, ajoute des sous-titres et hooks IA, puis publie automatiquement sur TikTok.

## ⚡ Installation (30 secondes)

```bash
curl -fsSL https://raw.githubusercontent.com/rayanmak/tikflow-app/main/install.sh | bash
```

Ou télécharge la dernière version depuis les [Releases](https://github.com/rayanmak/tikflow-app/releases).

## 🎯 Ce que fait TikFlow

- 📡 **Scan** 10 chaînes YouTube gaming FR
- 🎬 **Édite** des clips 65-90s (monétisables >1min)
- 🧠 **Génère** des hooks viraux via IA
- 📝 **Sous-titre** automatiquement (captions YouTube)
- 🎮 **Gameplay** intelligent (évite les zones mortes)
- 📤 **Publie** automatiquement sur TikTok
- 📊 **Dashboard** web sur http://localhost:5050

## 🖥️ Dashboard

Une fois lancé, ouvre http://localhost:5050 pour :
- Voir l'état du pipeline (factory, publisher, queue)
- Forcer une publication
- Voir les analytics (posts, succès, meilleurs horaires)
- Gérer la file d'attente

## 📦 Distribution

Télécharge `TikFlow.dmg` depuis les [Releases](https://github.com/rayanmak/tikflow-app/releases), ouvre-le, et glisse TikFlow dans Applications.

## 🔧 Développement

```bash
git clone https://github.com/rayanmak/tikflow-app.git
cd tikflow-app
./install.sh
```

## 📋 Requirements

- macOS 13+
- Python 3.11+
- FFmpeg (`brew install ffmpeg`)
- ImageMagick (`brew install imagemagick`)
- Compte TikTok avec session cookie valide

## 🔒 Privacy

TikFlow tourne 100% en local. Aucune donnée n'est envoyée à un serveur externe (sauf YouTube et TikTok pour les uploads).
