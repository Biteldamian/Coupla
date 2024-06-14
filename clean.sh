#!/bin/bash

# Function to print messages
print_message() {
  echo "========================================"
  echo "$1"
  echo "========================================"
}

# Clean npm cache
print_message "Cleaning npm cache..."
npm cache clean --force

wait 
# Clean Node.js cache
print_message "Cleaning Node.js cache..."
rm -rf ~/.npm
rm -rf ~/.node-gyp
rm -rf ~/.cache

wait 
# Clean mops cache
print_message "Cleaning mops cache..."
rm -rf .mops

wait 
# Clean dfx cache
print_message "Cleaning dfx cache..."
dfx cache delete

wait 
# Clean project-specific caches
print_message "Cleaning project-specific caches..."
rm -rf node_modules
rm -rf package-lock.json
rm -rf .dfx

wait 
print_message "Cache cleaning completed!"