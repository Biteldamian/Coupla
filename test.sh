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


# List all cells
echo "Listing all cells"
list_cells_result=$(sudo dfx canister call cupolaxs_blockchain_backend listCells)
echo "List cells result: $list_cells_result"

wait

# Get cell details
echo "Getting details for cell with ID 1"
cell_details_result=$(sudo dfx canister call cupolaxs_blockchain_backend getCellDetails "(1)")
echo "Cell details result: $cell_details_result"


wait

# Remove a cell
echo "Removing cell with ID 7"
remove_cell_result=$(sudo dfx canister call cupolaxs_blockchain_backend removeCell "(7)")
echo "Remove cell result: $remove_cell_result"

wait

# List all users
echo "Listing all users"
list_users_result=$(sudo dfx canister call cupolaxs_blockchain_backend listUsers)
echo "List users result: $list_users_result"

wait

# Remove a user
echo "Removing user: $current_principal"
remove_user_result=$(sudo dfx canister call cupolaxs_blockchain_backend removeUser "(principal \"$current_principal\")")
echo "Remove user result: $remove_user_result"

wait

# Add a user
echo "Adding user: $current_principal"
add_user_result=$(sudo dfx canister call cupolaxs_blockchain_backend addUser "(principal \"$current_principal\")")
echo "Add user result: $add_user_result"

wait

# Get token balance
echo "Getting token balance for user: $current_principal"
token_balance_result=$(sudo dfx canister call cupolaxs_blockchain_backend getTokenBalance "(principal \"$current_principal\")")
echo "Token balance result: $token_balance_result"

wait

# Mint tokens
echo "Minting tokens for user: $current_principal"
mint_tokens_result=$(sudo dfx canister call cupolaxs_blockchain_backend mintTokens "(principal \"$current_principal\", 1000)")
echo "Mint tokens result: $mint_tokens_result"

wait




# Book a cell
echo "Booking a cell for principal: $current_principal"
book_cell_result=$(sudo dfx canister call cupolaxs_blockchain_backend bookCell "(principal \"$current_principal\", 1, \"2023-10-01\")")
echo "Book cell result: $book_cell_result"

wait

# Make a payment
echo "Making payment from $current_principal to d3ubx-ngebm-gcgat-ggwoc-jd23u-bdbjy-svns7-zrb5q-4dwa2-d7wsy-7ae"
payment_result=$(sudo dfx canister call cupolaxs_blockchain_backend makePayment "(principal \"$current_principal\", principal \"d3ubx-ngebm-gcgat-ggwoc-jd23u-bdbjy-svns7-zrb5q-4dwa2-d7wsy-7ae\", 1)")
echo "Payment result: $payment_result"