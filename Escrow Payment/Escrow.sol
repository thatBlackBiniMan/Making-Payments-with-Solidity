// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzepplin/contracts/security/ReentrancyGuard.sol";


contract Escrow is ReentrancyGuard{
   address public escAcc;
   uint public escBal;
   uint public escAvailable;
   uint public escFee;
   uint public totalItems;
   uint public totalConfirmed;
   uint public totalDisputed;

   mapping(uint => itemStruct) items;
   mapping(address => itemStruct[]) itemsOf;
   
}