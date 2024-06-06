import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

module {
  // User-related types
  public type UserId = Principal;
  public type User = {
    id: UserId;
    balance: Balance;
    name: Text;
  };

  // Balance-related types
  public type Balance = Nat;
  public type Transaction = {
    from: UserId;
    to: UserId;
    amount: Balance;
    timestamp: Int;
  };

  // Booking-related types
  public type BookingId = Nat;
  public type Booking = {
    id: BookingId;
    user: UserId;
    item: Item;
    startTime: Int;
    endTime: Int;
    status: BookingStatus;
  };

  public type BookingStatus = {
    #pending;
    #confirmed;
    #canceled;
    #completed;
  };

  public type BookingError = {
    #bookingNotFound;
    #userNotFound;
    #invalidTime;
    #insufficientBalance;
  };

  // Item-related types
  public type Item = {
    name: Text;
    description: Text;
    url: Text;
  };

  // Payment-related types
  public type PaymentId = Nat;
  public type Payment = {
    id: PaymentId;
    from: UserId;
    to: UserId;
    amount: Balance;
    timestamp: Int;
    status: PaymentStatus;
  };

  public type PaymentStatus = {
    #pending;
    #completed;
    #failed;
  };

  public type PaymentError = {
    #paymentNotFound;
    #insufficientBalance;
    #transactionFailed;
  };

  // General Result type
  public type Result = Result.Result<(), Error>;

  // General Error type
  public type Error = {
    #userNotFound;
    #insufficientBalance;
    #bookingNotFound;
    #paymentNotFound;
    #invalidOperation;
  };
};