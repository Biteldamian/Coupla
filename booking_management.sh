#!/bin/bash

# Function to book a cell
book_cell() {
  local user_principal=$1
  local cell_id=$2
  local start_booking_date=$3
  local canister_id=$4
  dfx canister call $canister_id bookCell "(principal \"$user_principal\", $cell_id, \"$start_booking_date\")"
}

# Function to transfer tokens
transfer_tokens() {
  local from_user=$1
  local to_user=$2
  local amount=$3
  local canister_id=$4
  dfx canister call $canister_id transferTokens "(principal \"$from_user\", principal \"$to_user\", $amount)"
}

# Function to list all cells
list_cells() {
  local canister_id=$1
  dfx canister call $canister_id listCells
}