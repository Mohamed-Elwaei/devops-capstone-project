#!/bin/bash

echo "****************************************"
echo " Setting up Capstone Environment"
echo "****************************************"

# Try to use system Python if available
if command -v python3.10 &> /dev/null; then
    PYTHON_CMD="python3.10"
    echo "Using Python 3.10"
elif command -v python3.11 &> /dev/null; then
    PYTHON_CMD="python3.11"
    echo "Using Python 3.11"
elif command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    echo "Using system Python: $(python3 --version)"
else
    echo "ERROR: No Python found"
    exit 1
fi

echo "Installing Python virtual environment support"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-venv python3-pip

echo "Creating a Python virtual environment"
$PYTHON_CMD -m venv ~/venv

echo "Configuring the developer environment..."
if ! grep -q "DevOps Capstone Project additions" ~/.bashrc 2>/dev/null; then
    echo "# DevOps Capstone Project additions" >> ~/.bashrc
    echo "export GITHUB_ACCOUNT=$GITHUB_ACCOUNT" >> ~/.bashrc
    echo 'export PS1="\[\e]0;\u:\W\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ "' >> ~/.bashrc
    echo "source ~/venv/bin/activate" >> ~/.bashrc
fi

echo "Installing Python dependencies..."
source ~/venv/bin/activate
pip install --upgrade pip wheel

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "WARNING: requirements.txt not found"
fi

echo "Starting the Postgres Docker container..."
if docker ps -a --format '{{.Names}}' | grep -q "^postgresql$"; then
    echo "Removing existing PostgreSQL container..."
    docker stop postgresql 2>/dev/null
    docker rm postgresql 2>/dev/null
fi

make db

echo "Checking the Postgres Docker container..."
docker ps

echo "****************************************"
echo " Capstone Environment Setup Complete"
echo "****************************************"
echo ""
echo "Run 'source ~/venv/bin/activate' to activate the virtual environment"
echo ""