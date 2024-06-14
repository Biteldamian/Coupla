import Option "mo:base/Option";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Icrc1 "mo:icrc1/ICRC1";
import Types "/Types";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Nat8 "mo:base/Nat8";


shared ({ caller = _owner }) actor class Balances(
    token_args : Icrc1.TokenInitArgs,
) : async Icrc1.FullInterface {



    stable let token = Icrc1.init({
        token_args with minting_account = Option.get(
            token_args.minting_account,
            {
                owner = _owner;
                subaccount = null;
            },
        );
    });

    type UserId = Types.UserId;
    type Result = Types.Result;


    /// Functions for the ICRC1 token standard
    public shared query func icrc1_name() : async Text {
        Icrc1.name(token);
    };

    public shared query func icrc1_symbol() : async Text {
        Icrc1.symbol(token);
    };

    public shared query func icrc1_decimals() : async Nat8 {
        Icrc1.decimals(token);
    };

    public shared query func icrc1_fee() : async Icrc1.Balance {
        Icrc1.fee(token);
    };

    public shared query func icrc1_metadata() : async [Icrc1.MetaDatum] {
        Icrc1.metadata(token);
    };

    public shared query func icrc1_total_supply() : async Icrc1.Balance {
        Icrc1.total_supply(token);
    };

    public shared query func icrc1_minting_account() : async ?Icrc1.Account {
        ?Icrc1.minting_account(token);
    };

    public shared query func icrc1_balance_of(args : Icrc1.Account) : async Icrc1.Balance {
        Icrc1.balance_of(token, args);
    };

    public shared query func icrc1_supported_standards() : async [Icrc1.SupportedStandard] {
        Icrc1.supported_standards(token);
    };

    public shared ({ caller }) func icrc1_transfer(args : Icrc1.TransferArgs) : async Icrc1.TransferResult {
        await* Icrc1.transfer(token, args, caller);
    };

    public shared ({ caller }) func mint(args : Icrc1.Mint) : async Icrc1.TransferResult {
        await* Icrc1.mint(token, args, caller);
    };

    public shared ({ caller }) func burn(args : Icrc1.BurnArgs) : async Icrc1.TransferResult {
        await* Icrc1.burn(token, args, caller);
    };

    // Functions from the rosetta icrc1 ledger
    public shared query func get_transactions(req : Icrc1.GetTransactionsRequest) : async Icrc1.GetTransactionsResponse {
        Icrc1.get_transactions(token, req);
    };

    // Deposit cycles into this canister.
    public shared func deposit_cycles() : async () {
        let amount = ExperimentalCycles.available();
        Debug.print("BALANCES: Attempting to deposit cycles:");
        Debug.print(debug_show(amount));
        if (amount == 0) {
            Debug.print("BALANCES: No cycles available to deposit. Please send cycles to the canister.");
            return;
        };
        let accepted = ExperimentalCycles.accept<system>(amount);
        if (accepted == amount) {
            Debug.print("BALANCES: Deposited cycles successfully");
        } else {
            Debug.print("BALANCES: Failed to deposit cycles");
        };
        Debug.print("BALANCES: Accepted cycles:");
        Debug.print(debug_show(accepted));
    };

    /// Self-deployment logic
    public shared func deploy_self() : async () {
        let requiredCycles = 7_692_307_692; // Example required cycles for canister creation
        let availableCycles = ExperimentalCycles.available();
        Debug.print("Available cycles:");
        Debug.print(debug_show(availableCycles));
        if (availableCycles < requiredCycles) {
            Debug.print("Not enough cycles. Please deposit more cycles.");
            return;
        };
        let accepted = ExperimentalCycles.accept<system>(requiredCycles);
        if (accepted != requiredCycles) {
            Debug.print("Failed to accept required cycles for deployment");
            return;
        };
        Debug.print("Accepted required cycles for deployment");
        Debug.print("Token already initialized");
    };

}