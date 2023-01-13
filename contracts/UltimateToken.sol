// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library UltimateMapping {
    struct Map {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }

    function get(Map storage map, address key) public view isKeyInserted(map, key) returns (uint) {
        return map.values[key];
    }

    function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
        require(index < map.keys.length, "ArrayOutOfBound Exception");
        return map.keys[index];
    }

    function size(Map storage map) public view returns (uint) {
        return map.keys.length;
    }

    function set(Map storage map, address key, uint value) public {
        if (map.inserted[key]) {
            map.values[key] = value;
        } else {
            map.inserted[key] = true;
            map.values[key] = value;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }

    function remove(Map storage map, address key) public {
        if (!map.inserted[key]) {
            return;
        }

        delete map.inserted[key];
        delete map.values[key];

        uint index = map.indexOf[key];
        uint lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];

        map.indexOf[lastKey] = index;
        delete map.indexOf[key];

        map.keys[index] = lastKey;
        map.keys.pop();
    }
    modifier isKeyInserted(Map storage map, address key) {
        require(map.inserted[key], "There is no value for this address");
        _;
    }
}

contract UltimateToken {
    using UltimateMapping for UltimateMapping.Map;

    UltimateMapping.Map private balances;

    uint private _totalSupply;

    string private _name;
    string private _symbol;

    event Transfer(address indexed from, address indexed to, uint value);

    constructor() {
        _name = "UltimateToken";
        _symbol = "UTN";
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return 2;
    }

    function totalSupply() public view virtual returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns (uint) {
        return balances.get(account);
    }

    function transfer(address to, uint amount) public virtual returns (bool) {
        address from = msg.sender;
        require(from != address(0), "Transfer from the zero address");
        require(to != address(0), "Transfer to the zero address");

        uint fromBalance = balances.get(from);
        require(fromBalance >= amount, "Transfer amount greater than balance");
    unchecked {
        balances.set(from, fromBalance - amount);
        balances.set(to, balances.get(to) + amount);
    }

        emit Transfer(from, to, amount);
        return true;
    }

    function mint(address account, uint amount) internal virtual {
        require(account != address(0), "Mint to the 0 address");

        _totalSupply += amount;
    unchecked {
        balances.set(account, balances.get(account) + amount);
    }
        emit Transfer(address(0), account, amount);
    }
}