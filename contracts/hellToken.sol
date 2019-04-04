pragma solidity 0.5.7;

import "browser/safeMath.sol";

contract hellToken{
    
    using SafeMath for uint256;

    //Vars
    mapping (address => uint) public balanceOf;
    mapping (bytes32 => uint) public hated;
    mapping (bytes32 => bool) public hateTopic;
    mapping (uint256 => bytes32) public topicIndex;
    uint256 public lastIndex;
    address payable public owner;
    
    constructor() public{
        owner = msg.sender;
    }
    
    //params
    //@address: address to hold the tokens after created
    function iWannaHate () public payable{
        require(msg.value > 0);
        balanceOf[msg.sender] = msg.value;
    }
    
    //params
    //@address: address to hold the burned tokens
    //dev
    //The burned token can't be respent neither deleted
    function iHate (bytes32 _to, uint256 _hate) public{
        require(balanceOf[msg.sender]>= _hate);
        require(hateTopic[_to]);
        balanceOf[msg.sender].sub(_hate);
        hated[_to].add(_hate);
    }
    
    function iHateTooMuch (bytes32 _to, uint256 _hate) public{
        require(balanceOf[msg.sender]>= _hate);
        require(_hate > 10000);
        balanceOf[msg.sender].sub(_hate);
        hated[_to].add(_hate); 
        hateTopic[_to] = true;
        topicIndex[lastIndex +1] = _to;
        lastIndex += 1;
    }
    
    function toHeaven(uint256 _hate, bytes32 _to) public {
        require(_hate >= hated[_to]);
        balanceOf[msg.sender] -= _hate;
        hated[_to] = 0;
        hateTopic[_to] = false;
    }
    
    function redeem() public{
        require(msg.sender == owner);
        owner.send(address(this).balance);
    }
    
    function total() view public returns(uint256){
        return address(this).balance;
    }
}
