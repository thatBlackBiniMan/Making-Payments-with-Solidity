// SPDX-License-Identifier: MIT;
pragma solidity ^0.8.0;

contract Payroll {
  address public companyAcc;
  uint public companyBal;
  uint public totalWorkers;
  uint public totalSalary;
  uint public tatalPayment;


  mapping(address => bool) isWorker;
  PaymentStruct[] employees;


  event Paid (
     uint id,
     address indexed to,
     uint totalSalary;
     uint timestamp;

  );

  
  struct PaymentStruct {
    uint id;
    addressworker;
    uint salary;
    uint timestamp;

  }
  

  modifier ownerOnly(){
    require(msg.sender == companyAcc, "Not the Company");
    _:
  }


  constructor(){
    companyAcc = msg.sender;
  }
}