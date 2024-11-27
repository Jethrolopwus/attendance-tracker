// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttendanceTracker {
    address public owner;

    struct Employee {
        uint256 id;
        string name;
        address walletAddress;
        bool isRegistered;
    }

    struct Attendance {
        uint256 date; 
        bool isPresent;
    }

    mapping(address => Employee) public employees; 
    mapping(address => Attendance[]) public attendanceRecords; 
    address[] public employeeList; 

    event EmployeeRegistered(uint256 id, string name, address walletAddress);
    event AttendanceMarked(address employee, uint256 date, bool isPresent);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier onlyRegistered() {
        require(employees[msg.sender].isRegistered, "You are not a registered employee");
        _;
    }
    constructor() {
        owner = msg.sender;
    }

    function registerEmployee(uint256 id, string memory name, address walletAddress) public onlyOwner {
        require(!employees[walletAddress].isRegistered, "Employee already registered");
        employees[walletAddress] = Employee(id, name, walletAddress, true);
        employeeList.push(walletAddress);
        emit EmployeeRegistered(id, name, walletAddress);
    }

  
    function markAttendance(uint256 date, bool isPresent) public onlyRegistered {
        attendanceRecords[msg.sender].push(Attendance(date, isPresent));
        emit AttendanceMarked(msg.sender, date, isPresent);
    }

    function getAttendanceRecords(address employee) public view onlyOwner returns (Attendance[] memory) {
        require(employees[employee].isRegistered, "Employee not found");
        return attendanceRecords[employee];
    }

    function getTotalEmployees() public view returns (uint256) {
        return employeeList.length;
    }
}

