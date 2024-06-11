# usefull commands


# MacOS|
// see process running on port: like DFX in the backround
sudo lsof -i :4943  

// Kill process
sudo kill -9 10691  

# DFX
// Cache delete
sudo dfx cache delete 

// Start replica in background with 0 cansiters
sudo dfx start --clean --background

// Deposit Cycles into a cansiter
sudo dfx wallet send  bkyz2-fmaaa-aaaaa-qaaaq-cai 1000000000

// Pricipal for testing:
Wallet: default
The wallet canister on the "local" network for user "default" is "bnz7o-iuaaa-aaaaa-qaaaa-cai"

s7222-pws2u-oao2s-5rz6k-7v52u-widaj-n7tah-kdyqy-p5qss-i3l2v-bqe

cupolaxs_blockchain_frontend, with canister ID bd3sg-teaaa-aaaaa-qaaba-cai
cupolaxs_blockchain_backend, with canister ID bkyz2-fmaaa-aaaaa-qaaaq-cai 


dfx canister call cupolaxs_blockchain_backend makePayment '(principal "s7222-pws2u-oao2s-5rz6k-7v52u-widaj-n7tah-kdyqy-p5qss-i3l2v-bqe", principal "d3ubx-ngebm-gcgat-ggwoc-jd23u-bdbjy-svns7-zrb5q-4dwa2-d7wsy-7ae", 100)'



