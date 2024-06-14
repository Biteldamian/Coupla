import Principal "mo:base/Principal";
import Balances "./Balances";
import Types "./Types";
import Icrc1 "mo:icrc1/ICRC1";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Array "mo:base/Array";

actor class App(balancesAddr: Principal) = this {

  type Result = Types.Result;
  type UserId = Types.UserId;

  let balances = actor (Principal.toText(balancesAddr)) : Balances.Balances;

  stable var users: [Types.User] = [];
  stable var bookings: [Types.Booking] = [];
  stable var payments: [Types.Payment] = [];

  public func setBalance(user: Types.UserId, amount: Types.Balance): async Bool {
    let userOpt = Array.find(users, func(u: Types.User): Bool { return u.id == user; });
    switch (userOpt) {
      case (?user) {
        user.balance := amount;
        Debug.print("APP: Balance set successfully for user: " # Principal.toText(user.id));
        return true;
      };
      case null {
        Debug.print("APP: User not found: " # Principal.toText(user));
        return false;
      }
    }
  };

  public func getBalance(user: Types.UserId): async ?Types.Balance {
    let userOpt = Array.find(users, func(u: Types.User): Bool { return u.id == user; });
    switch (userOpt) {
      case (?user) return ?user.balance;
      case null return null;
    }
  };

  public func makePayment(from: Types.UserId, to: Types.UserId, amount: Types.Balance): async Result.Result<(), Types.Error> {
    Debug.print("APP: Initiating payment from " # Principal.toText(from) # " to " # Principal.toText(to) # " amount: " # Nat.toText(amount));
    let fromUserOpt = Array.find(users, func(u: Types.User): Bool { return u.id == from; });
    let toUserOpt = Array.find(users, func(u: Types.User): Bool { return u.id == to; });
    switch (fromUserOpt, toUserOpt) {
      case (?fromUser, ?toUser) {
        Debug.print("APP: Both users found");
        if (fromUser.balance >= amount) {
          fromUser.balance := fromUser.balance - amount;
          toUser.balance := toUser.balance + amount;
          payments := Array.append(payments, [{ id = payments.size(); from = from; to = to; amount = amount; timestamp = Time.now(); status = #completed }]);
          Debug.print("APP: Payment successful from " # Principal.toText(from) # " to " # Principal.toText(to));
          return #ok(());
        } else {
          Debug.print("APP: Insufficient balance for user: " # Principal.toText(from));
          return #err(#insufficientBalance);
        }
      };
      case (null, _) {
        Debug.print("APP: From user not found");
        return #err(#userNotFound);
      };
      case (_, null) {
        Debug.print("APP: To user not found");
        return #err(#userNotFound);
      };
    }
  };

  public func payment(from: Principal, to: Principal, amount: Nat) : async (Result) {
    let balance = await balances.icrc1_balance_of({ owner = from; subaccount = null });
    if (amount > balance) return #err(#insufficientBalance);

    let transferArgs = {
      from = { owner = from; subaccount = null };
      to = { owner = to; subaccount = null };
      amount = amount;
      created_at_time = null;
      fee = null;
      from_subaccount = null;
      memo = null;
    };
    let transferResult = await balances.icrc1_transfer(transferArgs);
    switch (transferResult) {
      case (#ok(_)) {
        return #ok();
      };
      case (#err(err)) {
        let customErr = switch (err) {
          case (#InsufficientFunds(_)) #insufficientBalance;
          case (#TemporarilyUnavailable) #invalidOperation;
          case (#TooOld) #invalidOperation;
          // Add other cases based on the actual error variants provided by the ICRC1 library
          case (_) #invalidOperation; // Generic catch-all for other errors
        };
        return #err(customErr);
      };
    }
  };
};