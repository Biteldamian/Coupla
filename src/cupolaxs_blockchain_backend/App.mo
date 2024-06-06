import Principal "mo:base/Principal";

import Balances "./Balances";
import Types "./Types";

actor class App(balancesAddr: Principal) = App {

  type Result = Types.Result;
  type UserId = Types.UserId;

  let balances = actor (Principal.toText(balancesAddr)) : Balances.Balances;

  public func payment(user: Principal, amount: Nat) : async (Result) {
    let balance = await balances.getBalance(user);
    if (amount > balance) return #err(#insufficientBalance);

    let myPrincipal = Principal.fromActor(App);
    ignore balances.transfer(user, myPrincipal, amount);
    #ok()
  };

};