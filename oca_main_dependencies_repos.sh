#!/bin/bash
# -*- encoding: utf-8 -*-
ODOO_VERSION="15.0"
GITHUB_USER="admininnovansis"
OE_USER="odoo"
OE_HOME="/$OE_USER"
OE_HOME_EXT="$OE_HOME/custom/repos"

# List of GitHub repositories to clone
REPOS=(
    "server-brand"
    "server-tools"
    "web"
    "server-auth"
    "server-backend"
    "rest-framework"
    "queue"
    "server-env"
    "website"
    "server-ux"
    "connector"
)
# /odoo/custom/repos/server-brand,/odoo/custom/repos/server-tools,/odoo/custom/repos/web,/odoo/custom/repos/server-auth,/odoo/custom/repos/server-backend,/odoo/custom/repos/rest-framework,/odoo/custom/repos/queue,/odoo/custom/repos/server-env,/odoo/custom/repos/website,/odoo/custom/repos/server-ux,/odoo/custom/repos/connector
# Virtual environment name
ODOO_VENV="odoo-$ODOO_VERSION"

# Create or activate the virtual environment
if [ ! -d "$OE_HOME/.virtualenvs/$ODOO_VENV" ]; then
    echo "Creating virtual environment $ODOO_VENV..."
    sudo su $OE_USER -c "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv -a $OE_HOME/.virtualenvs $ODOO_VENV"
fi

# Iterate over the repositories and clone/update them
for REPO in "${REPOS[@]}"; do
    REPO_NAME=$(basename $REPO)
    REPO_URL="git@github.com:$GITHUB_USER/$REPO.git"
    
    echo "Processing repository: $REPO_NAME"
    
    if [ ! -d "./$REPO_NAME" ]; then
        echo "Cloning $REPO_NAME from $REPO_URL..."
        sudo su $OE_USER -c "git clone --depth 1 $REPO_URL -b $ODOO_VERSION $OE_HOME_EXT/${REPO}"
    fi

    # Install dependencies if a requirements.txt file is present
    if [ -f "$OE_HOME_EXT/$REPO_NAME/requirements.txt" ]; then
        echo "Installing dependencies for $REPO_NAME..."
        sudo su $OE_USER -c "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && workon $ODOO_VENV && pip3 install -r $OE_HOME_EXT/$REPO_NAME/requirements.txt"
    else
        echo "No dependencies found for $REPO_NAME."
    fi
done

echo "All repositories have been processed."
