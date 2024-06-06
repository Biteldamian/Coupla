export const idlFactory = ({ IDL }) => {
  const CellId = IDL.Nat;
  const BookingStatus = IDL.Variant({
    'canceled' : IDL.Null,
    'pending' : IDL.Null,
    'completed' : IDL.Null,
    'confirmed' : IDL.Null,
  });
  const UserId = IDL.Principal;
  const Cell = IDL.Record({
    'id' : CellId,
    'status' : BookingStatus,
    'bookedBy' : IDL.Opt(UserId),
    'dateEndBooking' : IDL.Text,
    'dateStartBooking' : IDL.Text,
    'isBooked' : IDL.Bool,
    'price' : IDL.Nat,
  });
  return IDL.Service({
    'addCell' : IDL.Func([Cell], [], []),
    'addUser' : IDL.Func([IDL.Principal], [], []),
    'bookCell' : IDL.Func([UserId, CellId, IDL.Int], [IDL.Bool], []),
    'checkCell' : IDL.Func([CellId], [IDL.Opt(Cell)], ['query']),
    'deployAll' : IDL.Func([], [], []),
    'deployApp' : IDL.Func([], [], []),
    'deployBalances' : IDL.Func([], [], []),
    'getCellDetails' : IDL.Func([CellId], [IDL.Opt(Cell)], ['query']),
    'isReady' : IDL.Func([], [IDL.Bool], ['query']),
    'listCells' : IDL.Func([], [IDL.Vec(Cell)], ['query']),
    'makePayment' : IDL.Func([UserId, UserId, IDL.Nat], [IDL.Bool], []),
    'registerUser' : IDL.Func([IDL.Principal], [IDL.Bool], []),
    'removeCell' : IDL.Func([IDL.Nat], [], []),
    'removeUser' : IDL.Func([IDL.Principal], [], []),
    'setBalance' : IDL.Func([UserId, IDL.Nat], [IDL.Bool], []),
    'setCell' : IDL.Func([Cell], [], []),
    'updateCellEndDate' : IDL.Func([CellId, IDL.Text], [IDL.Bool], []),
  });
};
export const init = ({ IDL }) => { return []; };
