import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Prim "mo:prim";
import App "/App";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Balances "/Balances";
import Types "/Types";



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
            case (?bal) Debug.print("Already deployed");
            case (_) {
                let tempBalances = await Balances.Balances();
                await tempBalances.deposit(msg.caller, 100);
                balances := ?tempBalances;
            };
        }
    };

    public func deployApp() : async () {
        switch (app, balances) {
            case (?a, _) Debug.print("Already deployed");
            case (_, null) Debug.print("Should call deployBalances() first");
            case (_, ?bal) {
                let tempApp = await App.App(Principal.fromActor(bal));
                app := ?tempApp;
            };
        }
    };

    // deployAll() replies immediately after initiating but not awaiting the asynchronous deployments
    public func deployAll() : async () {
        ignore async {
            await deployBalances();
            ignore deployApp(); // requires Balances
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
                await bal.deposit(user, amount);
                return true;
            };
            case (_) return false;
        }
    };

    // Function to make a payment from one user to another
   public func makePayment(from: UserId, to: UserId, amount: Nat): async Bool {
    switch (balances) {
        case (?bal) {
            let result = await bal.transfer(from, to, amount);
            switch (result) {
                case (#ok) return true;
                case (#err(err)) {
                    let errMsg = switch (err) {
                        case (#bookingNotFound) "bookingNotFound";
                        case (#insufficientBalance) "insufficientBalance";
                        case (#invalidOperation) "invalidOperation";
                        case (#paymentNotFound) "paymentNotFound";
                        case (#userNotFound) "userNotFound";
                    };
                    Debug.print("Payment error: " # errMsg);
                    return false;
                };
            }
        };
        case (_) return false;
    }
};

}
