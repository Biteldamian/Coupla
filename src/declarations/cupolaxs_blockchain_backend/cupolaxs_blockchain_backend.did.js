export const idlFactory = ({ IDL }) => {
  const UserId = IDL.Principal;
  const CellId = IDL.Nat;
  const Cell = IDL.Record({
    'id' : CellId,
    'bookedBy' : IDL.Opt(UserId),
    'dateEndBooking' : IDL.Text,
    'dateStartBooking' : IDL.Text,
    'isBooked' : IDL.Bool,
    'price' : IDL.Nat,
  });
  return IDL.Service({
    'bookCell' : IDL.Func([UserId, CellId, IDL.Text], [IDL.Bool], []),
    'checkCell' : IDL.Func([CellId], [IDL.Opt(Cell)], ['query']),
    'getCellDetails' : IDL.Func([CellId], [IDL.Opt(Cell)], ['query']),
    'listCells' : IDL.Func([], [IDL.Vec(Cell)], ['query']),
    'registerUser' : IDL.Func([IDL.Principal], [IDL.Bool], []),
    'updateCellEndDate' : IDL.Func([CellId, IDL.Text], [IDL.Bool], []),
  });
};
export const init = ({ IDL }) => { return []; };
