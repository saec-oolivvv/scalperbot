#!/bin/bash
set -e

# --- CONFIGURATION ---
GITHUB_USER="saec-oolivvv"           # Ton nom d’utilisateur GitHub
GITHUB_REPO_NAME="scalperbot"        # Nom du dépôt GitHub
GITHUB_VISIBILITY="public"           # public ou private
GIT_USER_NAME="SAEC Expert"          # Nom Git pour Git
GIT_USER_EMAIL="sa.expert.consult@gmail.com" # Email Git pour GitHub

# Dossier du projet
PROJECT_DIR="$(pwd)"

echo "🟢 Création de la structure des dossiers du projet..."

# Crée les dossiers principaux
mkdir -p backend frontend alembic traefik installer-electron

# Crée des fichiers placeholders pour Git
touch backend/.gitkeep
touch frontend/.gitkeep
touch alembic/.gitkeep
touch traefik/.gitkeep
touch installer-electron/.gitkeep

echo "🟢 Structure créée avec succès."

# --- Configuration Git ---
echo "🟢 Configuration Git..."
git init || echo "Git déjà initialisé"
git config user.name "$GIT_USER_NAME"
git config user.email "$GIT_USER_EMAIL"

# --- Commit initial ---
echo "🟢 Ajout des fichiers et commit initial..."
git add .
git commit -m "Initial commit - ScalperBot full version" || echo "Aucun nouveau commit à créer"

# --- Détecter si le dépôt GitHub existe ---
if gh repo view "$GITHUB_USER/$GITHUB_REPO_NAME" >/dev/null 2>&1; then
    echo "ℹ️ Le dépôt '$GITHUB_REPO_NAME' existe déjà. Poussage dans le dépôt existant..."
    # Supprime l'ancien remote si nécessaire
    git remote remove origin 2>/dev/null || true
    git remote add origin "https://github.com/$GITHUB_USER/$GITHUB_REPO_NAME.git"
else
    echo "🟢 Création du dépôt GitHub via GitHub CLI..."
    gh repo create "$GITHUB_USER/$GITHUB_REPO_NAME" --"$GITHUB_VISIBILITY" --source="$PROJECT_DIR" --remote=origin --push
    exit 0
fi

# --- Pousser vers GitHub ---
echo "🟢 Poussage des fichiers vers le dépôt existant..."
git push -u origin master

echo "✅ Dépôt GitHub mis à jour avec succès !"
echo "🌐 Tu peux accéder à ton repo : https://github.com/$GITHUB_USER/$GITHUB_REPO_NAME"
