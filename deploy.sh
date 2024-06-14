#!/bin/bash

# Function to handle errors
handle_error() {
  echo "Error on line $1"
  exit 1
}

# Trap errors
trap 'handle_error $LINENO' ERR

sudo dfx stop
echo "Stopped Replica "

wait

# DFX
# Cache delete
echo "Deleting DFX cache..."
sudo dfx cache delete
wait 
echo "Deleted DFX cache..."
wait
# Start the replica
sudo dfx start --clean --background
echo "Starting DFX replica in the background..."

wait
# Deploy canisters
sudo dfx deploy
echo "Deploying canisters..."

wait

# Deploy Balances
sudo dfx canister call cupolaxs_blockchain_backend --wallet $(dfx identity get-wallet) --with-cycles 9000000000 deployBalances
echo "Deploying Balances..."

wait

# Deploy App
sudo dfx canister call cupolaxs_blockchain_backend --wallet $(dfx identity get-wallet) --with-cycles 9000000000 deployApp
echo "Deploying App..."

wait

# Deploy all
sudo dfx canister call cupolaxs_blockchain_backend deployAll
echo "Deploying all canisters..."

wait

# Check if ready
sudo dfx canister call cupolaxs_blockchain_backend isReady
echo "Checking if App && Balance is ready..."

wait

# Get the current principal
current_principal=$(dfx identity get-principal)

# Register the current principal
echo "Registering principal: $current_principal"
register_result=$(sudo dfx canister call cupolaxs_blockchain_backend registerUser "(principal \"$current_principal\")")
echo "Register result: $register_result"

wait

# Set balance for the current principal
echo "Setting balance for principal: $current_principal"
set_balance_result=$(sudo dfx canister call cupolaxs_blockchain_backend setBalance "(principal \"$current_principal\", 1000000)")
echo "Set balance result: $set_balance_result"

wait
sudo dfx canister call cupolaxs_blockchain_backend setBalance "(principal \"$current_principal\", 1000000)"
echo "Set balance result: $set_balance_result"

wait
sudo dfx canister call cupolaxs_blockchain_backend setBalance "(principal \"s7222-pws2u-oao2s-5rz6k-7v52u-widaj-n7tah-kdyqy-p5qss-i3l2v-bqe\", 1000000)"
