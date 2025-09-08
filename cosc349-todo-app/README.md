# COSC349 Assignment 1 - Multi-VM Todo Application

A Todo List application demonstrating virtualization across three separate VMs using Vagrant.

## Architecture

This application is built using **three Virtual Machines**:

1. **Database VM** (192.168.56.11) - MySQL Server
2. **Backend VM** (192.168.56.12) - Node.js API Server  
3. **Frontend VM** (192.168.56.13) - Nginx Web Server

## Quick Start

### Prerequisites
- VirtualBox installed
- Vagrant installed
- At least 3GB RAM available for VMs

### Running the Application
```bash
# Clone the repository
git clone <your-repo-url>
cd cosc349-todo-app

# Start all VMs (automated build)
./build.sh

# Or manually:
vagrant up

# Access the application
# Open http://localhost:8080 in your browser