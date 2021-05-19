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
    uint256 private _profit;
    uint256 private _prize;
    uint256 private _currentBlockNb;
    uint256 private _newGameDuration;
    uint256 private _setGameDuration;
    
    // Events
    
    event lasted(uint256 indexed block);
    event Transfered(address indexed sender, uint256 value);
    event betted(address indexed sender, uint256 value);
    
    // Constructor
    
    constructor(address owner_, uint256 initilaPot_, uint256 setGameDuration_) payable {
        require(initilaPot_ > 0, "KingOfTheHill: The initial pot cannot be 0.");
        require(setGameDuration_ > 0, "The game duration cannot be 0.");
        _pot = initilaPot_;
        _owner = owner_;
        _setGameDuration = setGameDuration_;
        _currentBlockNb = block.number;
        _gameDuration = _currentBlockNb + setGameDuration_;
    }
    
    // Modifier
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "KingOfTheHill: Only owner can call this function.");
        _;
    }

    // Function declarations
    
    receive() external payable {
    }
    
    function bet() public payable {
         if(block.number >= _gameDuration) {
             win();
         }
        require(msg.value > _pot * 2, "KingOfTheHill: You cannot bid for less than two times the pot.");
        payable(msg.sender).sendValue(msg.value - (_pot * 2));
        _pot += _pot * 2;
        _temporaryKing = msg.sender;
        emit Transfered(msg.sender, _pot * 2);
    }
    
    
    function win() public payable {
        _prize = Prize();
        _seed = Seed();
        _profit = Seed();
        payable(_temporaryKing).sendValue(_prize);
        payable(_owner).sendValue(_profit);
        emit Transfered(_temporaryKing, _prize);
        emit Transfered(_owner, _profit);
        _prize = 0;
        _pot = 0;
        _pot += _seed;
        _newGameDuration = block.number + _setGameDuration;

    }
    //1000000000000000 : 1 finney
    
    function Prize() public view returns(uint256) {
        return _pot * 80 / 100;
    }
    
    function Seed() public view returns(uint256) {
        return (_pot - _prize) / 2;
    }
    
    function Pot() public view returns(uint256) {
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