// SPDX-License-Identifier: MIT;
pragma solidity ^0.8.0;

contract Payroll {
  address public companyAcc;
  uint public companyBal;
  uint public totalWorkers;
  uint public totalSalary;
  uint public tatalPayment;


  mapping(address => bool) workerExist;
  EmployeeStruct[] employees;


  event Paid (
     uint id,
     address indexed from,
     uint totalSalary;
     uint timestamp;

  );

  
  struct EmployeeStruct {
    uint id;
    address worker;
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

  function addEmployee(address worker, uint salary) public ownerOnly returns(bool){
     require(salary > 0 ether, "Salary Must be above zero");
     require(!workerExist[worker], "Already an Employee");    
    
    totalWorkers++;
    totalSalary += salary;
    workerExist[worker] = true;

    employees.push(
      EmployeeStruct[
        totalWorkers,
        worker,
        salary,
        block.timestamp
      ]
    );
    return true;
  }


function payEmployees() public ownerOnly returns (bool){
  require(companyBal >= totalSalary, "Insufficient Balance" );

  for(uint i = 0; i < employees.length; i++){
     payTo(employees[i].worker, employees[i].salary);
  }
 totalPayment++;
 companyBal -= totalSalary;


 emit Paid(
  totalPayment,
  companyAcc,
  totalSalary,
  block.timestamp

 );

 return true;

}


function name(type name) {
  
}



function payTo(address to, uint amount) internal returns (bool){
  (bool succeded, ) = payable(to).call{value: amount}("");
  require(succeded, "Payment failed");
  return true;
  }

}