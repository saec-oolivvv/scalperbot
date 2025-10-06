#!/bin/bash
set -e

# --- CONFIGURATION ---
GITHUB_REPO_NAME="scalperbot"        # Nom du dépôt GitHub
GITHUB_VISIBILITY="public"           # public ou private
GIT_USER_NAME="SAEC Expert"          # Ton nom Git
GIT_USER_EMAIL="sa.expert.consult@gmail.com" # Ton email GitHub

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
git commit -m "Initial commit - ScalperBot full version"

# --- Créer le dépôt GitHub ---
echo "🟢 Création du dépôt GitHub via GitHub CLI..."
gh repo create "$GITHUB_REPO_NAME" --"$GITHUB_VISIBILITY" --source="$PROJECT_DIR" --remote=origin --push

echo "✅ Dépôt GitHub créé et fichiers poussés avec succès !"
echo "🌐 Tu peux accéder à ton repo : https://github.com/$(gh auth status --show-token | grep Logged | awk '{print $4}')/$GITHUB_REPO_NAME"
