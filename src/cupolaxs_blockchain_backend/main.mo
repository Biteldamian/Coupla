import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Prim "mo:prim";
import App "/App";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Nat8 "mo:base/Nat8";
import Balances "/Balances";
import Types "/Types";
import Icrc1 "mo:icrc1/ICRC1";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Nat "mo:base/Nat";
import Bool "mo:base/Bool";



actor {
    type Result<S, T> = Result.Result<S, T>; 
    type App = App.App;
    type UserId = Principal;
    type Balances = Balances.Balances;
    type CellId = Nat;
    

    type Cell = {
        id: CellId;
        isBooked: Bool;
        bookedBy: ?UserId;
        price: Nat;
        dateStartBooking: Text;
        dateEndBooking: Text;
        status: Types.BookingStatus;
    };


  var app : ?App = null;
  var balances : ?Balances = null;
  
    // Performs initial setup operations by instantiating the Balances and App canisters
    public shared(msg) func deployBalances() : async () {
        switch (balances) {
            case (?bal) Debug.print("MAIN: Balances already deployed");
            case (_) {
                let requiredCycles = 7_692_307_692; // Example required cycles for canister creation
                let availableCycles = ExperimentalCycles.available();
                Debug.print("Available cycles:");
                Debug.print(debug_show(availableCycles));
                if (availableCycles < requiredCycles) {
                    Debug.print("MAIN: Not enough cycles. Please deposit more cycles.");
                    return;
                };
                let accepted = ExperimentalCycles.accept<system>(requiredCycles);
                assert (accepted == requiredCycles);
                Debug.print("MAIN: Accepted required cycles for Balances deployment");
                
                // Attach cycles to the canister creation call
                ExperimentalCycles.add(200_000_000_000);
                let tempBalances = await Balances.Balances({
                    name = "MyToken";
                    symbol = "MTK";
                    decimals = 8;
                    fee = 0;
                    initial_balances = [];
                    minting_account = null;
                    transfer_fee = null;
                    metadata = [];
                    advanced_settings = null;
                    max_supply = 1_000_000_000_000_000_000; // Example max supply
                    min_burn_amount = 0; // Example min burn amount
                },); // Attach the accepted cycles here
                balances := ?tempBalances;
                Debug.print("MAIN: Balances deployed successfully");
                Debug.print(debug_show(accepted));
            };
        }
    };
    // Deposit cycles into this canister.
       public shared func deposit_cycles() : async () {
        let amount = ExperimentalCycles.available();
        Debug.print("MAIN: Attempting to deposit cycles:");
        Debug.print(debug_show(amount));
        if (amount == 0) {
            Debug.print("MAIN: No cycles available to deposit. Please send cycles to the canister.");
            return;
        };
        let accepted = ExperimentalCycles.accept<system>(amount);
        ExperimentalCycles.add(200_000_000_000);
        if (accepted == amount) {
            Debug.print("MAIN: Deposited cycles successfully");
        } else {
            Debug.print("MAIN: Failed to deposit cycles");
        };
        Debug.print("MAIN: Accepted cycles:");
        Debug.print(debug_show(accepted));
    };

    public func deployApp() : async () {
         ExperimentalCycles.add(200_000_000_000);
            switch (app, balances) {
                case (?a, _) Debug.print("MAIN: Already deployed");
                case (_, null) Debug.print("MAIN: Should call deployBalances() first");
                case (_, ?bal) {
                    let tempApp = await App.App(Principal.fromActor(bal));
                    app := ?tempApp;
                    Debug.print("MAIN: App deployed successfully");
                };
            }
        };

        // deployAll() replies immediately after initiating but not awaiting the asynchronous deployments
        public func deployAll() : async () {
            ignore async {
                await deployBalances();
                Debug.print("MAIN: Deploying Balances");
                if (await isReady()) {
                    await deployApp(); // requires Balances
                    Debug.print("MAIN: Deploying App");
                } else {
                    Debug.print("MAIN: Balances deployment failed or not ready");
                }
            };
        };

    // isReady() replies promptly (and is a cheap query)
    public query func isReady() : async Bool {
        switch(balances, app) {
            case (? _, ? _) true;
            case _ false;
        }
    };


    private var cells: [Cell] = [
        { id = 1; isBooked = false; bookedBy = null; price = 1; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 2; isBooked = false; bookedBy = null; price = 5; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 3; isBooked = false; bookedBy = null; price = 1; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 4; isBooked = false; bookedBy = null; price = 1; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 5; isBooked = false; bookedBy = null; price = 1; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 6; isBooked = false; bookedBy = null; price = 1; dateStartBooking = ""; dateEndBooking = ""; status = #pending }
    ];
    private var users: [UserId] = [];
    
  public func registerUser(user: Principal): async Bool {
    Debug.print("MAIN: Attempting to register user: " # Principal.toText(user));
    // Check if user already exists
    if (Array.find(users, func(u: UserId): Bool { return u == user; }) == null) {
        // Use Array.append for clarity
        users := Array.append(users, [user]);
        Debug.print("MAIN: User registered successfully: " # Principal.toText(user));
        return true;
    } else {
        Debug.print("MAIN: User already registered: " # Principal.toText(user));
    };
    return false;
};
     
public func bookCell(userId: Principal, cellId: Nat, dateStart: Text): async Bool {
    let cellOpt = Array.find(cells, func(c: Cell): Bool { return c.id == cellId });
    switch (cellOpt) {
        case (?cell) {
            if (cell.isBooked) {
                Debug.print("MAIN: Cell not found or already booked");
                return false;
            } else {
                // Deduct the cell price from the user's balance
                let price = cell.price;
                let paymentResult = await makePayment(userId, Principal.fromText("your-canister-principal"), price);
                if (not paymentResult) {
                    Debug.print("MAIN: Payment failed");
                    return false;
                };

                // Update the cell booking details
                let updatedCell = {
                    id = cell.id;
                    isBooked = true;
                    bookedBy = ?userId;
                    price = cell.price;
                    dateStartBooking = dateStart;
                    dateEndBooking = cell.dateEndBooking;
                    status = #confirmed;
                };
                await setCell(updatedCell);
                Debug.print("MAIN: Cell booked successfully");
                return true;
            }
        };
        case (_) {
            Debug.print("MAIN: Cell not found or already booked");
            return false;
        }
    }
};


    public func updateCellEndDate(id: CellId, newEndDate: Text): async Bool {
          var updated = false;
          cells := Array.map(cells, func(c : Cell) : Cell {
              if (c.id == id and c.isBooked) {
                  updated := true;
                  return {
                      id = c.id;
                      isBooked = c.isBooked;
                      bookedBy = c.bookedBy;
                      price = c.price;
                      dateStartBooking = c.dateStartBooking;
                      dateEndBooking = newEndDate;
                      status = #confirmed;
                  };
              };
              return c;
          });
          return updated;
      };

    
    public query func checkCell
    (id: CellId): async ?Cell {
        return Array.find(cells, func(c : Cell) : Bool { c.id == id });
    };

    public query func listCells(): async [Cell] {
        return cells;
    };


    public func removeCell(cellId: Nat): async () {
        cells := Array.filter(cells, func(c : Cell) : Bool { c.id!= cellId });
        };

    public func addCell(cell: Cell): async () {
        cells := Array.append(cells, [cell]);
        };

    public query func getCellDetails(cellId: CellId): async ?Cell {
      return Array.find(cells, func(c: Cell): Bool { return c.id == cellId });
    };
        public func setCell(cell: Cell): async () {
        cells := Array.map(cells, func(c : Cell) : Cell {
            if (c.id == cell.id) {
                return cell;
            };
            return c;
        });
    };

    

    public func removeUser(userId: Principal): async () { 
        users := Array.filter(users, func(u : UserId) : Bool { u!= userId });
        };
    public func addUser(userId: Principal): async () {
        users := Array.append(users, [userId]);
    };

    // Function to set balance for a user
    public func setBalance(user: UserId, amount: Nat): async Bool {
        switch (balances) {
            case (?bal) {
                let mintArgs = {
                    to = { owner = user; subaccount = null };
                    amount = amount;
                    created_at_time = null;
                    memo = null;
                };
                let result = await bal.mint(mintArgs);
                    switch (result) {
                        case (#Ok(_)){
                            Debug.print("MAIN: Mint succesful");
                            return true;
                        };
                        case (#Err(err)) {
                            let errorMessage = switch (err) {
                                case (#BadBurn { min_burn_amount }) "Bad burn: min burn amount is  ";
                                case (#BadFee { expected_fee }) "Bad fee: expected fee is ";
                                case (#CreatedInFuture { ledger_time }) "Created in future: ledger time is ";
                                case (#Duplicate { duplicate_of }) "Duplicate: duplicate of ";
                                case (#GenericError { error_code }) "Generic error: code";
                                case (#InsufficientFunds { balance }) "Insufficient funds: balance is ";
                                case (#TemporarilyUnavailable) "Temporarily unavailable";
                                case (#TooOld) "Too old";
                            };
                            Debug.print("MAIN: Mint error: " # errorMessage);
                            return false;
                        };
                    }
                };
                case (_) {
                    Debug.print("MAIN: Balances not initialized");
                    return false;
                }
            }
            };

    // Function to mint tokens to a user's wallet
    public func mintTokens(user: UserId, amount: Nat): async Bool {
        return await setBalance(user, amount);
    };

    public func getTokenBalance(user: UserId): async Nat {
        Debug.print("MAIN: Getting token balance for user: " # Principal.toText(user));
        switch (balances) {
            case (?bal) {
                let balance = await bal.icrc1_balance_of({ owner = user; subaccount = null });
                Debug.print("MAIN: Token balance for user " # Principal.toText(user) # " is " # Nat.toText(balance));
                return balance;
            };
            case (_) {
                Debug.print("Balances not deployed");
                return 0;
            };
        }
    };


  // Function to make a payment from one user to another
        public func makePayment(from: UserId, to: UserId, amount: Nat): async Bool {
        switch (app) {
            case (?a) {
                let result = await a.payment(from, to, amount); // Include the 'to' parameter in the payment call
                switch (result) {
                    case (#ok) {
                        Debug.print("MAIN: Payment successful");
                        return true;
                    };
                    case (#err(err)) {
                        let errorMessage = switch (err) {
                            case (#insufficientBalance) "Insufficient balance";
                            case (#invalidOperation) "Invalid operation";
                            // Add other cases based on the actual error variants provided by the ICRC1 library
                            case (_) "Unknown error"; // Generic catch-all for other errors
                        };
                        Debug.print("MAIN: Payment error: " # errorMessage);
                        return false;
                    };
                }
            };
            case (_) {
                Debug.print("MAIN: App not initialized");
                return false;
            }
        }
    };


    // Function to list all users
    public query func listUsers(): async [UserId] {
        return users;
    };
    

}
