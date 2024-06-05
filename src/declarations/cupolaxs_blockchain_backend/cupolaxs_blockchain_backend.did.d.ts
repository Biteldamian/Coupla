import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Cell {
  'id' : CellId,
  'bookedBy' : [] | [UserId],
  'dateEndBooking' : string,
  'dateStartBooking' : string,
  'isBooked' : boolean,
  'price' : bigint,
}
export type CellId = bigint;
export type UserId = Principal;
export interface _SERVICE {
  'bookCell' : ActorMethod<[UserId, CellId, string], boolean>,
  'checkCell' : ActorMethod<[CellId], [] | [Cell]>,
  'getCellDetails' : ActorMethod<[CellId], [] | [Cell]>,
  'listCells' : ActorMethod<[], Array<Cell>>,
  'registerUser' : ActorMethod<[Principal], boolean>,
  'updateCellEndDate' : ActorMethod<[CellId, string], boolean>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
