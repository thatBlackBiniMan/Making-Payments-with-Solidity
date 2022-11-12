// SPDX-License-Identifier: MIT;
pragma solidity ^0.8.0;

contract KryptoStore{
  uint public tax;
  address immutable taxAccount;
  uint totalSupply;

   struct KryptoStruct{
    uint id;
    address seller;
    string name;
    string description;
    string author;
    uint cost;
    uint timestamp;
   }

}