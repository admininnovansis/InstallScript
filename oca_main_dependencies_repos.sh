#!/bin/bash
# -*- encoding: utf-8 -*-
ODOO_VERSION="15.0"
GITHUB_USER="admininnovansis"

# List of GitHub repositories to clone
REPOS=(
    "OCA/server-brand"
    "OCA/server-tools"
    "OCA/web"
    "OCA/server-auth"
    "OCA/server-backend"
    "OCA/rest-framework"
    "OCA/queue"
    "OCA/server-env"
    "OCA/website"
    "OCA/server-ux"
    "OCA/connector"
)

# Virtual environment name
ODOO_VENV="odoo-$ODOO_VERSION"

# Create or activate the virtual environment
if [ ! -d "~/.virtualenvs/$ODOO_VENV" ]; then
    echo "Creating virtual environment $ODOO_VENV..."
    mkvirtualenv $ODOO_VENV
else
    echo "Activating virtual environment $ODOO_VENV..."
    workon $ODOO_VENV
fi

# Iterate over the repositories and clone/update them
for REPO in "${REPOS[@]}"; do
    REPO_NAME=$(basename $REPO)
    REPO_URL="https://github.com:$GITHUB_USER/$REPO.git"
    
    echo "Processing repository: $REPO_NAME"
    
    if [ ! -d "./$REPO_NAME" ]; then
        echo "Cloning $REPO_NAME from $REPO_URL..."
        git clone --depth 1 $REPO_URL -b $ODOO_VERSION
    else
        echo "The repository $REPO_NAME already exists. Updating..."
        cd $REPO_NAME
        git pull
        cd ..
    fi

    # Install dependencies if a requirements.txt file is present
    if [ -f "./$REPO_NAME/requirements.txt" ]; then
        echo "Installing dependencies for $REPO_NAME..."
        pip3 install -r ./$REPO_NAME/requirements.txt
    else
        echo "No dependencies found for $REPO_NAME."
    fi
done

echo "All repositories have been processed."
