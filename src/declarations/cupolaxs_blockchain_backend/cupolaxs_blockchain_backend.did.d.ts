import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type BookingStatus = { 'canceled' : null } |
  { 'pending' : null } |
  { 'completed' : null } |
  { 'confirmed' : null };
export interface Cell {
  'id' : CellId,
  'status' : BookingStatus,
  'bookedBy' : [] | [UserId],
  'dateEndBooking' : string,
  'dateStartBooking' : string,
  'isBooked' : boolean,
  'price' : bigint,
}
export type CellId = bigint;
export type UserId = Principal;
export interface _SERVICE {
  'addCell' : ActorMethod<[Cell], undefined>,
  'addUser' : ActorMethod<[Principal], undefined>,
  'bookCell' : ActorMethod<[UserId, CellId, bigint], boolean>,
  'checkCell' : ActorMethod<[CellId], [] | [Cell]>,
  'deployAll' : ActorMethod<[], undefined>,
  'deployApp' : ActorMethod<[], undefined>,
  'deployBalances' : ActorMethod<[], undefined>,
  'deposit_cycles' : ActorMethod<[], undefined>,
  'getCellDetails' : ActorMethod<[CellId], [] | [Cell]>,
  'getTokenBalance' : ActorMethod<[UserId], bigint>,
  'isReady' : ActorMethod<[], boolean>,
  'listCells' : ActorMethod<[], Array<Cell>>,
  'makePayment' : ActorMethod<[UserId, UserId, bigint], boolean>,
  'mintTokens' : ActorMethod<[UserId, bigint], boolean>,
  'registerUser' : ActorMethod<[Principal], boolean>,
  'removeCell' : ActorMethod<[bigint], undefined>,
  'removeUser' : ActorMethod<[Principal], undefined>,
  'setBalance' : ActorMethod<[UserId, bigint], boolean>,
  'setCell' : ActorMethod<[Cell], undefined>,
  'updateCellEndDate' : ActorMethod<[CellId, string], boolean>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
