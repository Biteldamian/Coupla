import Principal "mo:base/Principal";
import Balances "./Balances";
import Types "./Types";
import Icrc1 "mo:icrc1/ICRC1";


actor class App(balancesAddr: Principal) = this {

  type Result = Types.Result;
  type UserId = Types.UserId;

  let balances = actor (Principal.toText(balancesAddr)) : Balances.Balances;

  public func payment(user: Principal, amount: Nat) : async (Result) {
    let balance = await balances.icrc1_balance_of({ owner = user; subaccount = null });
    if (amount > balance) return #err(#insufficientBalance);

    let myPrincipal = Principal.fromActor(this);
    let transferArgs = {
      from = { owner = user; subaccount = null };
      to = { owner = myPrincipal; subaccount = null };
      amount = amount;
      created_at_time = null;
      fee = null;
      from_subaccount = null;
      memo = null;
    };
    let transferResult = await balances.icrc1_transfer(transferArgs);
    switch (transferResult) {
      case (#Ok(_)) {
        return #ok();
      };
      case (#Err(err)) {
              let customErr = switch (err) {
                case (#BadBurn(_)) #invalidOperation;
                case (#BadFee(_)) #invalidOperation;
                case (#CreatedInFuture(_)) #invalidOperation;
                case (#Duplicate(_)) #invalidOperation;
                case (#GenericError(_)) #invalidOperation;
                case (#InsufficientFunds(_)) #insufficientBalance;
                case (#TemporarilyUnavailable) #invalidOperation;
                case (#TooOld) #invalidOperation;
              };
              return #err(customErr);
            };
          }
  };

};