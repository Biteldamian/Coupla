#!/bin/bash

# Function to register a user
register_user() {
  local user_principal=$1
  local canister_id=$2
  dfx canister call $canister_id registerUser "(principal \"$user_principal\")"
}

# Function to list all users
list_users() {
  local canister_id=$1
  dfx canister call $canister_id listUsers
}

# Function to remove a user
remove_user() {
  local user_principal=$1
  local canister_id=$2
  dfx canister call $canister_id removeUser "(principal \"$user_principal\")"
}

# Function to create or use an identity
create_or_use_identity() {
  local user_name=$1
  dfx identity new $user_name || dfx identity use $user_name
  dfx identity get-principal
}

# Function to register a user if not exists
register_user_if_not_exists() {
  local user_principal=$1
  local canister_id=$2
  register_user $user_principal $canister_id
}

# Function to send tokens to a user
send_tokens() {
  local user_principal=$1
  local amount=$2
  local canister_id=$3
  dfx canister call $canister_id mintTokens "(principal \"$user_principal\", $amount)"
}

# Function to get the balance of a user
get_balance() {
  local user_principal=$1
  local canister_id=$2
  dfx canister call $canister_id getTokenBalance "(principal \"$user_principal\")"
}