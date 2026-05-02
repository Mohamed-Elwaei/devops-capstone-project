#!/bin/bash
set -e

echo "****************************************"
echo " Setting up Capstone Environment"
echo "****************************************"

echo "Using system Python 3"
sudo apt-get update
sudo apt-get install -y python3 python3-venv python3-pip

echo "Checking Python version..."
python3 --version

echo "Creating Python virtual environment"
python3 -m venv ~/venv

echo "Configuring the developer environment..."
if ! grep -q "DevOps Capstone Project additions" ~/.bashrc; then
    echo "# DevOps Capstone Project additions" >> ~/.bashrc
    echo "export GITHUB_ACCOUNT=$GITHUB_ACCOUNT" >> ~/.bashrc
    echo 'export PS1="\[\e]0;\u:\W\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ "' >> ~/.bashrc
    echo "source ~/venv/bin/activate" >> ~/.bashrc
fi

echo "Installing Python dependencies..."
source ~/venv/bin/activate
python3 -m pip install --upgrade pip wheel
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "WARNING: requirements.txt not found"
fi

# Rest of script remains the same...