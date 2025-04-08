#!/bin/bash

#============== COLORS ==============
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#============== HEADER ==============
echo "=============================="
echo "🛠️  Welcome to the DevOps Automation Script"
echo "📦 Powered by Bash"
echo "=============================="

#============== Load Environment Variables ==============
if [[ -f .env ]]; then
    source .env
else
    echo -e "${RED}❌ .env file not found! Please create one with DOCKER_USERNAME and DOCKER_TOKEN.${NC}"
    exit 1
fi

#============== Detect OS ==============
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$NAME
        OS_VERSION=$VERSION
    else
        echo "⚠️  Unable to detect operating system!"
        exit 1
    fi

    echo "🔍 Detected Operating System: $OS_NAME ($OS_VERSION)"

    if [[ "$OS_NAME" != "Ubuntu" ]]; then
        echo "🚧 $OS_NAME is not supported yet. Coming soon!"
        exit 0
    fi
}

#============== Package Installers ==============
install_package_if_missing() {
    local package=$1
    if ! command -v "$package" &> /dev/null; then
        echo "📥 $package is not installed. Installing..."
        sudo apt-get update -y
        sudo apt-get install "$package" -y
    else
        echo "✅ $package is already installed."
    fi
}

#============== Docker Setup ==============
setup_docker() {
    if ! command -v docker &> /dev/null; then
        echo "🐳 Installing Docker..."
        sudo apt-get install docker.io -y
    fi

    if ! systemctl is-active --quiet docker; then
        echo "🔄 Starting Docker service..."
        sudo systemctl start docker
        sudo systemctl enable docker
    fi

    echo "✅ Docker is ready!"
}

#============== Cleanup Docker ==============
cleanup_docker() {
    echo "🧹 Cleaning up Docker containers and images..."
    local all_containers=$(sudo docker ps -aq)
    if [[ -n "$all_containers" ]]; then
        echo "🗑️ Removing all containers (running + stopped)..."
        sudo docker rm -f $all_containers
    fi

    local images=$(sudo docker images -q)
    if [[ -n "$images" ]]; then
        echo "🗑️ Removing existing images..."
        sudo docker rmi -f $images
    fi
}

#============== Check & Free Port ==============
check_and_free_port() {
    local port=8081
    local pid=$(sudo lsof -t -i :$port)

    if [[ -n "$pid" ]]; then
        echo -e "${YELLOW}⚠️ Port $port is in use by PID $pid. Stopping process...${NC}"
        sudo kill -9 $pid
        echo -e "${GREEN}✅ Port $port has been freed.${NC}"
    else
        echo -e "${GREEN}✅ Port $port is free.${NC}"
    fi
}

#============== Clone Repository ==============
clone_repo() {
    local repo_path="$HOME/nehadjsh/RentCarManagement"
    if [ ! -d "$repo_path" ]; then
        echo "📁 Cloning project repository..."
        git clone https://github.com/nehadjsh/RentCarManagement.git "$repo_path"
    else
        echo "📁 Project already exists at $repo_path"
    fi

    cd "$repo_path" || exit
}

#============== Build and Push Docker Image ==============
build_and_push_docker() {
    echo "🐳 Building Docker image 'rentcars'..."
    sudo docker build -t rentcars .

    echo "🔐 Logging into Docker Hub..."
    echo "$DOCKER_TOKEN" | sudo docker login -u "$DOCKER_USERNAME" --password-stdin

    echo "🚀 Tagging and pushing image..."
    sudo docker tag rentcars "$DOCKER_USERNAME/rentcars:latest"
    sudo docker push "$DOCKER_USERNAME/rentcars:latest"
}

#============== Run and Verify App ==============
run_and_verify() {
    echo "📥 Pulling latest image from Docker Hub..."
    sudo docker pull "$DOCKER_USERNAME/rentcars:latest"

    echo "🚗 Running the Docker container..."
    sudo docker run -d --name carwebapp -p 8081:8081 "$DOCKER_USERNAME/rentcars:latest"

    echo "🔍 Verifying application health..."
    sleep 5
    local status_code=$(curl -o /dev/null -s -w "%{http_code}" http://localhost:8081)

    if [[ "$status_code" == "200" ]]; then
        echo -e "${GREEN}✅ The car web app is working!${NC}"
    else
        echo -e "${RED}❌ The app is not responding. Status code: $status_code${NC}"
    fi
}

#============== Main Script Execution ==============
detect_os
install_package_if_missing curl
install_package_if_missing git
setup_docker
cleanup_docker
check_and_free_port
clone_repo
build_and_push_docker
run_and_verify
