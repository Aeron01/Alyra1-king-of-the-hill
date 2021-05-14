// SPDX-License-Identifier: MIT

// testNet :
// address contract:
// adress owner:

pragma solidity ^0.8.0;

// import

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract KingOfTheHill {
    
    // library usage
    
    using Address for address payable;
    
    // State Variables
    
    address private _owner;
    uint256 private _pot;
    uint256 private _gameDuration;
    address private _temporaryKing;
    address private _king;
    uint256 private _seed;
    uint256 private _prize;
    uint256 private _currentBlockNb;
    
    // Events
    
    event lasted(uint256 indexed block);
    event Transfered(address indexed sender, uint256 value);
    event betted(address indexed sender, uint256 value);
    
    // Constructor
    
    constructor(address owner_, uint256 initilaPot_, uint256 gameDuration_) payable {
        require(owner_ == "","KingOfTheHill: You must enter the address of the owner.")
        require(initilaPot_ >= 0, "KingOfTheHill: ")
        _pot = initilaPot_;
        _owner = owner_;
        _currentBlockNb = block.number;
        _gameDuration = _currentBlockNb + gameDuration_;
    }
    
    // Modifier
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "KingOfTheHill: Only owner can call this function.");
        _;
    }

    // Function declarations
    
    receive() external payable {
        _bet(msg.sender, msg.value);
    }
    
    function bet() external payable {
        require(msg.value > _pot * 2, "KingOfTheHill: You cannot bid for less than two times the pot.");
        _bet(msg.sender, msg.value);
        _pot += msg.value;
        _temporaryKing = msg.sender;
        emit Transfered(msg.sender, msg.value);
    }
    
    
    function prize() public view returns(uint256) {
        return _pot * 80 / 100;
    }
    
    function seed() public view returns(uint256) {
        return _pot - _prize / 2;
    }
    
    function pot() public view returns(uint256) {
        return _pot;
    }
    
    function king() public view returns(address) {
        return _king;
    }
    
    function temporaryKing() public view returns(address) {
        return _temporaryKing;
    }
    
    function owner() public view returns(address) {
        return _owner;
    }

    function _bet(address sender, uint256 value) private {
        emit betted(sender, value);
    }

}