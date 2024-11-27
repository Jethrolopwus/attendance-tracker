// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/AttendanceTracker.sol";

contract AttendanceTrackerScript is Script {
    AttendanceTracker public tracker;

    address owner = vm.addr(1); 
    address employee1 = vm.addr(2);
    address employee2 = vm.addr(3); 

    function setUp() public {
       
        vm.startBroadcast(owner); 
    }

    function run() public {
        tracker = new AttendanceTracker();
        console.log("AttendanceTracker deployed at:", address(tracker));

    
        tracker.registerEmployee(1, "John", employee1);
        tracker.registerEmployee(2, "Alice", employee2);
        console.log("Registered employees John and Alice");

        vm.prank(employee1); 
        tracker.markAttendance(block.timestamp, true);
        console.log("Attendance marked for Alice");

        vm.prank(employee2); 
        tracker.markAttendance(block.timestamp, false);
        console.log("Attendance marked for John");

        AttendanceTracker.Attendance[] memory records1 = tracker.getAttendanceRecords(employee1);
        console.log("Attendance records for Alice:", records1.length);

        AttendanceTracker.Attendance[] memory records2 = tracker.getAttendanceRecords(employee2);
        console.log("Attendance records for John:", records2.length);

        uint256 totalEmployees = tracker.getTotalEmployees();
        console.log("Total employees registered:", totalEmployees);

        vm.stopBroadcast();
    }
}
