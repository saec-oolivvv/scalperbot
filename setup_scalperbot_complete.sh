#!/bin/bash
set -e

# --- CONFIGURATION ---
GITHUB_USER="saec-oolivvv"
GITHUB_REPO_NAME="scalperbot"
GITHUB_VISIBILITY="public"
GIT_USER_NAME="SAEC Expert"
GIT_USER_EMAIL="sa.expert.consult@gmail.com"

PROJECT_DIR="$(pwd)"

echo "🟢 Création de la structure des dossiers ScalperBot..."

# Crée les dossiers principaux
mkdir -p backend frontend alembic traefik installer-electron

# Fichiers backend
cat > backend/app.py <<EOL
from flask import Flask, jsonify
app = Flask(__name__)

@app.route("/")
def index():
    return jsonify({"message": "ScalperBot backend running!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOL

cat > backend/requirements.txt <<EOL
flask==2.3.2
psycopg2-binary==2.9.9
requests==2.31.0
pandas==2.1.1
EOL

cat > backend/config.py <<EOL
# Configuration placeholder
POSTGRES_USER = "saec"
POSTGRES_PASSWORD = "saec123"
POSTGRES_DB = "scalperbot"
EOL

# Fichiers frontend
cat > frontend/index.html <<EOL
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>ScalperBot Dashboard</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <h1>ScalperBot Dashboard</h1>
  <div id="charts"></div>
  <script src="dashboard.js"></script>
</body>
</html>
EOL

cat > frontend/dashboard.js <<EOL
console.log("ScalperBot dashboard loaded");
// Ajoute ici Chart.js ou D3.js pour les graphiques temps réel
EOL

cat > frontend/styles.css <<EOL
body { font-family: Arial, sans-serif; background-color: #111; color: #eee; }
#charts { width: 90%; margin: auto; height: 400px; }
EOL

cat > frontend/package.json <<EOL
{
  "name": "scalperbot-frontend",
  "version": "1.0.0",
  "dependencies": {}
}
EOL

# Fichiers Docker
cat > Dockerfile <<EOL
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "app.py"]
EOL

cat > docker-compose.yml <<EOL
version: '3.8'
services:
  backend:
    build: ./backend
    container_name: scalperbot_backend
    ports:
      - "5000:5000"
    environment:
      - POSTGRES_USER=saec
      - POSTGRES_PASSWORD=saec123
      - POSTGRES_DB=scalperbot
    depends_on:
      - db

  frontend:
    build: ./frontend
    container_name: scalperbot_frontend
    ports:
      - "8080:80"
    depends_on:
      - backend

  db:
    image: postgres:15
    container_name: scalperbot_postgres
    environment:
      - POSTGRES_USER=saec
      - POSTGRES_PASSWORD=saec123
      - POSTGRES_DB=scalperbot
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOL

# Fichiers Traefik et Electron placeholders
touch alembic/.gitkeep
cat > traefik/traefik.yml <<EOL
# Traefik placeholder
EOL
cat > installer-electron/main.js <<EOL
// Electron placeholder
EOL

# README et gitignore
cat > README.md <<EOL
# ScalperBot
Version complète du bot de scalping crypto.

## Installation
1. Copier ce dépôt
2. Configurer .env si nécessaire
3. docker-compose up -d
4. Accéder au dashboard sur http://<NAS_IP>:8080
EOL

cat > .gitignore <<EOL
__pycache__/
*.pyc
*.env
node_modules/
dist/
EOL

# --- Git ---
echo "🟢 Initialisation Git..."
git init || echo "Git déjà initialisé"
git config user.name "$GIT_USER_NAME"
git config user.email "$GIT_USER_EMAIL"

git add .
git commit -m "Initial commit - ScalperBot full version"

# --- GitHub ---
if gh repo view "$GITHUB_USER/$GITHUB_REPO_NAME" >/dev/null 2>&1; then
    echo "ℹ️ Le dépôt existe déjà. Poussage dans le dépôt existant..."
    git remote remove origin 2>/dev/null || true
    git remote add origin "https://github.com/$GITHUB_USER/$GITHUB_REPO_NAME.git"
else
    echo "🟢 Création du dépôt GitHub..."
    gh repo create "$GITHUB_USER/$GITHUB_REPO_NAME" --"$GITHUB_VISIBILITY" --source="$PROJECT_DIR" --remote=origin --push
    exit 0
fi

echo "🟢 Poussage des fichiers vers GitHub..."
git push -u origin master

echo "✅ ScalperBot complet créé et poussé sur GitHub !"
