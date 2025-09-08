#!/bin/bash
echo "=== COSC349 Todo Application - Multi-VM Build ==="
echo "Starting 3 Virtual Machines..."
echo ""

# Start all VMs
vagrant up

echo ""
echo "=== Build Complete ==="
echo ""
echo "Application URLs:"
echo "  Frontend (Web UI): http://localhost:8080"
echo "  Backend API:       http://localhost:3001/api/health"
echo "  Database:          localhost:33061 (MySQL)"
echo ""
echo "VM IP Addresses:"
echo "  Frontend VM:  192.168.56.13"
echo "  Backend VM:   192.168.56.12" 
echo "  Database VM:  192.168.56.11"
echo ""
echo "To view VM status: vagrant status"
echo "To SSH into VMs:   vagrant ssh [database|backend|frontend]"