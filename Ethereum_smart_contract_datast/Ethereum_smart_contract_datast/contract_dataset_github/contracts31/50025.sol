// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.4;

abstract contract DateTimeAPI {
    /*
    *  Abstract contract for interfacing with the DateTime contract.
    *
    */
    function isLeapYear(uint16 year) public virtual pure returns (bool);
    function getYear(uint timestamp) public virtual pure returns (uint16);
    function getMonth(uint timestamp) public virtual pure returns (uint8);
    function getDay(uint timestamp) public virtual pure returns (uint8);
    function getHour(uint timestamp) public virtual pure returns (uint8);
    function getMinute(uint timestamp) public virtual pure returns (uint8);
    function getSecond(uint timestamp) public virtual pure returns (uint8);
    function getWeekday(uint timestamp) public virtual pure returns (uint8);
    function toTimestamp(uint16 year, uint8 month, uint8 day) public virtual pure returns (uint32 timestamp);
    function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public virtual pure returns (uint32 timestamp);
    function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public virtual pure returns (uint32 timestamp);
    function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public virtual pure returns (uint32 timestamp);
}
