# 🤖 TikFlow — TikTok Automation Pipeline

**Pipeline TikTok 100% automatisé pour macOS.**

TikFlow scanne des chaînes YouTube, extrait les meilleurs moments, ajoute des sous-titres et hooks IA, puis publie automatiquement sur TikTok.

## ⚡ Installation (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/mkinvest57/tikflow-app/main/install.sh | bash
```

Ça installe TOUT automatiquement : Homebrew, Python 3.12, FFmpeg, ImageMagick, dépendances Python, Chromium, et l'app dans /Applications.

Ou télécharge le **DMG** depuis les [Releases](https://github.com/mkinvest57/tikflow-app/releases).

## 🎯 TikFlow v3

- **Orb navigation** — boule en verre flottante, 3 pétales qui fleurissent sur un arc
- **Panneaux rétractables** — clic sur le titre pour ouvrir/fermer
- **Paramètres modifiables** — intervalle, durée, queue, vidéos/jour en live
- **Chaînes YouTube** — ajout/suppression depuis le dashboard
- **Notifications Telegram** — config intégrée avec bouton test
- **Limite quotidienne** — VIDEOS_PER_DAY actif avec avertissement
- **Design Apple blanc pur** — zéro sidebar, zéro bleu

## 📊 Dashboard

http://localhost:5050

## 📦 Requirements (gérés automatiquement par install.sh)

- macOS 13+
- Python 3.11+
- FFmpeg, ImageMagick
- Compte TikTok avec session cookie

## 🔒 Privacy

100% local. Aucune donnée externe (sauf YouTube et TikTok pour les uploads).
