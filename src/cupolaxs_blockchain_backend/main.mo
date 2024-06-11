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
            case (?bal) Debug.print("Balances already deployed");
            case (_) {
                let requiredCycles = 7_692_307_692; // Example required cycles for canister creation
                let availableCycles = ExperimentalCycles.available();
                Debug.print("Available cycles:");
                Debug.print(debug_show(availableCycles));
                if (availableCycles < requiredCycles) {
                    Debug.print("Not enough cycles. Please deposit more cycles.");
                    return;
                };
                let accepted = ExperimentalCycles.accept<system>(requiredCycles);
                assert (accepted == requiredCycles);
                Debug.print("Accepted required cycles for Balances deployment");
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
                });
                balances := ?tempBalances;
                Debug.print("Balances deployed successfully");
            };
        }
    };
    // Deposit cycles into this canister.
       public shared func deposit_cycles() : async () {
        let amount = ExperimentalCycles.available();
        Debug.print("Attempting to deposit cycles:");
        Debug.print(debug_show(amount));
        if (amount == 0) {
            Debug.print("No cycles available to deposit. Please send cycles to the canister.");
            return;
        };
        let accepted = ExperimentalCycles.accept<system>(amount);
        if (accepted == amount) {
            Debug.print("Deposited cycles successfully");
        } else {
            Debug.print("Failed to deposit cycles");
        };
        Debug.print("Accepted cycles:");
        Debug.print(debug_show(accepted));
    };

    public func deployApp() : async () {
            switch (app, balances) {
                case (?a, _) Debug.print("Already deployed");
                case (_, null) Debug.print("Should call deployBalances() first");
                case (_, ?bal) {
                    let tempApp = await App.App(Principal.fromActor(bal));
                    app := ?tempApp;
                    Debug.print("App deployed successfully");
                };
            }
        };

        // deployAll() replies immediately after initiating but not awaiting the asynchronous deployments
        public func deployAll() : async () {
            ignore async {
                await deployBalances();
                Debug.print("Deploying Balances");
                if (await isReady()) {
                    await deployApp(); // requires Balances
                    Debug.print("Deploying App");
                } else {
                    Debug.print("Balances deployment failed or not ready");
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
        { id = 1; isBooked = false; bookedBy = null; price = 0; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 2; isBooked = false; bookedBy = null; price = 0; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 3; isBooked = false; bookedBy = null; price = 0; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 4; isBooked = false; bookedBy = null; price = 0; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 5; isBooked = false; bookedBy = null; price = 0; dateStartBooking = ""; dateEndBooking = ""; status = #pending },
        { id = 6; isBooked = false; bookedBy = null; price = 0; dateStartBooking = ""; dateEndBooking = ""; status = #pending }
    ];
    private var users: [UserId] = [];
    
    public func registerUser(user: Principal): async Bool {
         // Check if user already exists
         if (Array.find(users, func(u: UserId): Bool { return u == user; }) == null) {
             // Use Array.append for clarity
             users := Array.append(users, [user]);
             return true;
         };
         return false;
     };
   public func bookCell(user: UserId, id: CellId, startBookingDate: Int): async Bool {
        var found = false;
        cells := Array.map(cells, func(c : Cell) : Cell {
            if (c.id == id and c.status == #pending) {
                found := true;
                return {
                id = c.id;
                isBooked = true;
                bookedBy = ?user;
                price = c.price;
                dateStartBooking = "";
                dateEndBooking = ""; // Reset end booking date
                status = #confirmed;
            };
            };
            return c;
        });
        return found;
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

    
    public query func checkCell(id: CellId): async ?Cell {
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
                            Debug.print("Mint succesful");
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
                            Debug.print("Mint error: " # errorMessage);
                            return false;
                        };
                    }
                };
                case (_) {
                    Debug.print("Balances not initialized");
                    return false;
                }
            }
            };

  // Function to make a payment from one user to another
    public func makePayment(from: UserId, to: UserId, amount: Nat): async Bool {
        switch (app) {
            case (?a) {
                let result = await a.payment(from, amount);
                switch (result) {
                    case (#ok) {
                        Debug.print("Payment successful");
                        return true;
                    };
                    case (#err(err)) {
                        let errorMessage = switch (err) {
                            case (#bookingNotFound) "Booking not found";
                            case (#insufficientBalance) "Insufficient balance";
                            case (#invalidOperation) "Invalid operation";
                            case (#paymentNotFound) "Payment not found";
                            case (#userNotFound) "User not found";
                        };
                        Debug.print("Payment error: " # errorMessage);
                        return false;
                    };
                }
            };
            case (_) {
                Debug.print("App not initialized");
                return false;
            }
        }
    };

}
