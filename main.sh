#!/bin/bash

# Source the user management and booking management scripts
source ./user_management.sh
source ./booking_management.sh

# Function to display the menu
display_menu() {
  echo "Select an option:"
  echo "1. Register a new user"
  echo "2. Mint tokens to a user"
  echo "3. Check user balance"
  echo "4. List all users"
  echo "5. List all cells"
  echo "6. Book a room"
  echo "7. Transfer tokens to a user"
  echo "8. Exit"
}

# Get the canister ID for the backend
BACKEND_CANISTER_ID=$(dfx canister id cupolaxs_blockchain_backend)

# Main loop
while true; do
  display_menu
  read -p "Enter your choice: " choice

  case $choice in
    1)
      read -p "Enter the user name: " user_name
      user_principal=$(create_or_use_identity $user_name)
      register_user_if_not_exists $user_principal $BACKEND_CANISTER_ID
      read -p "Enter the amount of tokens to assign: " amount
      send_tokens $user_principal $amount $BACKEND_CANISTER_ID
      get_balance $user_principal $BACKEND_CANISTER_ID
      ;;
    2)
      read -p "Enter the user principal: " user_principal
      read -p "Enter the amount of tokens to mint: " amount
      send_tokens $user_principal $amount $BACKEND_CANISTER_ID
      get_balance $user_principal $BACKEND_CANISTER_ID
      ;;
    3)
      read -p "Enter the user principal: " user_principal
      get_balance $user_principal $BACKEND_CANISTER_ID
      ;;
    4)
      list_users $BACKEND_CANISTER_ID
      ;;
    5)
      list_cells $BACKEND_CANISTER_ID
      ;;
    6)
      read -p "Enter the user principal: " user_principal
      read -p "Enter the cell ID: " cell_id
      read -p "Enter the start booking date: " start_booking_date
      book_cell $user_principal $cell_id $start_booking_date $BACKEND_CANISTER_ID
      ;;
    7)
      read -p "Enter your principal: " from_user
      read -p "Enter the recipient's principal: " to_user
      read -p "Enter the amount of tokens to transfer: " amount
      transfer_tokens $from_user $to_user $amount $BACKEND_CANISTER_ID
      ;;
    8)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac
done