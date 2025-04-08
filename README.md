# 🚀 DevOps Automation Script with Bash

This project is a Bash script that automates the process of preparing a complete DevOps environment. It includes steps like installing required packages, setting up Docker, cleaning up old containers/images, managing ports, cloning a repository, building Docker images, pushing to Docker Hub, and verifying application health — all in one go!

---

## 🧰 Features

- ✅ Detects operating system (supports Ubuntu)
- ✅ Installs required packages (vim, curl, git)
- 🐳 Installs and configures Docker
- 🗑️ Cleans up running & stopped containers and Docker images
- 🔌 Frees up port `8081` if in use
- 📁 Clones your GitHub repository
- 🔧 Builds and pushes Docker images to Docker Hub
- 🚀 Runs and verifies the web application using `curl`
- 🔐 Loads sensitive credentials (Docker Hub login) from a `.env` file
```
. ├── devops-automation.sh # Main automation script ├── .env # Environment variables file (not uploaded to GitHub) └── README.md # This file
```
---

## 📂 Project Structure

# DevOps-Bash-Automation


---

## 🔐 Environment Variables

To keep your credentials secure and flexible, create a file named `.env` in the same directory:

```
DOCKER_USERNAME=your_dockerhub_username
DOCKER_TOKEN=your_personal_access_token
```
⚠️ Do not push your .env file to GitHub. Add it to .gitignore to keep it safe.

---

## 🧪 How to Use
1. Clone this repo:

```
git clone https://github.com/yourusername/devops-bash-automation.git
cd devops-bash-automation
```
2. Create your .env file and add your Docker Hub credentials.

3. Give permission and run the script:

```
chmod +x devops-automation.sh
./devops-automation.sh
```

---

## 📝 Notes
- This script uses curl to verify your application is up and running on port 8081.
- Modify the script to fit your app's port or image name if needed.
- You must generate a Docker Hub Personal Access Token instead of using your password:
- Go to Docker Hub → Account Settings → Security
- Click "New Access Token" and use that in your .env

---

## 📦 Example Output
- 🛠️  Welcome to the DevOps Automation Script
- 🔍 Detected Operating System: Ubuntu (22.04)
- ✅ curl is already installed.
- 🐳 Docker is ready!
- 🗑️ Removing running containers...
- ✅ Port 8081 has been freed.
- 📁 Cloning project repository...
- 🐳 Building Docker image 'rentcars'...
- ✅ The car web app is working!

  
---

## 📌 Author
Developed by @nehadjsh — always building cool stuff with DevOps & automation ❤️

---

## 🛡️ License
This project is open-source and available under the MIT License.







