// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/AttendanceTracker.sol";

contract AttendanceTrackerTest is Test {
    AttendanceTracker tracker;

    address owner = address(1);
    address employee1 = address(2);
    address employee2 = address(3);

    function setUp() public {
        vm.prank(owner);
        tracker = new AttendanceTracker();
    }

    function testRegisterEmployee() public {
        vm.prank(owner);
        tracker.registerEmployee(1, "Alice", employee1);

        (uint256 id, string memory name, address walletAddress, bool isRegistered) = tracker.employees(employee1);

        assertEq(id, 1);
        assertEq(name, "Alice");
        assertEq(walletAddress, employee1);
        assertEq(isRegistered, true);

        vm.expectRevert("Only the owner can perform this action");
        vm.prank(employee1);
        tracker.registerEmployee(2, "John", employee2);
    }

    function testMarkAttendance() public {
        vm.prank(owner);
        tracker.registerEmployee(1, "Alice", employee1);

        vm.prank(employee1);
        tracker.markAttendance(block.timestamp, true);
        vm.prank(owner);
        AttendanceTracker.Attendance[] memory records = tracker.getAttendanceRecords(employee1);

        assertEq(records.length, 1);
        assertEq(records[0].date, block.timestamp);
        assertEq(records[0].isPresent, true);
        vm.expectRevert("You are not a registered employee");
        vm.prank(employee2);
        tracker.markAttendance(block.timestamp, true);
    }

    function testGetAttendanceRecords() public {
        vm.prank(owner);
        tracker.registerEmployee(1, "Alice", employee1);
        vm.prank(owner);
        tracker.registerEmployee(2, "John", employee2);
        vm.prank(employee1);
        tracker.markAttendance(block.timestamp, true);

        vm.prank(employee2);
        tracker.markAttendance(block.timestamp, false);

        vm.prank(owner);
        AttendanceTracker.Attendance[] memory records1 = tracker.getAttendanceRecords(employee1);
        assertEq(records1.length, 1);
        assertEq(records1[0].isPresent, true);

        vm.prank(owner);
        AttendanceTracker.Attendance[] memory records2 = tracker.getAttendanceRecords(employee2);
        assertEq(records2.length, 1);
        assertEq(records2[0].isPresent, false);

        vm.expectRevert("Only the owner can perform this action");
        vm.prank(employee1);
        tracker.getAttendanceRecords(employee2);
    }

    function testGetTotalEmployees() public {
        vm.prank(owner);
        tracker.registerEmployee(1, "Alice", employee1);

        vm.prank(owner);
        tracker.registerEmployee(2, "John", employee2);

        uint256 totalEmployees = tracker.getTotalEmployees();
        assertEq(totalEmployees, 2);
    }
}
