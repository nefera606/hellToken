pragma solidity ^0.4.15;

import "./ERC20Interface.sol"
import "./Ownable.sol"

/// @title Test token contract - Allows testing of token transfers with multisig wallet.
contract HateToken is ERC20Interface, Ownable {

    /*
     *  Events
     */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event SomeoneHatesYou(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /*
     *  Constants
     */
    string constant public name = "Hell Token";
    string constant public symbol = "666";
    uint8 constant public decimals = 0;
    uint8 constant public hellPrice = 1000000000000; // around 1/10th of a US cent (500$/eth)
    /* uint8 constant public hellWall = 100000000000000000000; */

    /*
     *  Storage
     */
    mapping (address => uint256) balances;
    mapping (address => uint256) hellReceived;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;

    /*
     * Public functions
     */
     function () payable {
       buyHellTokens(msg.sender);
     };

    /// @dev Issues new tokens 1 token per wei.
    /// @param _to Address of token receiver.
    function buyHellTokens(address _to)
        public payable
    {
        balances[_to] += msg.value / hellPrice;
        totalSupply += _value;
        /* updateHellPrice(); */
    }

    /* function updateHellPrice(){
      if (totalSupply > hellWall){
        hellPrice = hellPrice * 2;
        hellWall = hellWall * 2;
      }
    } */

    function fundtransfer onlyOwner (address etherreceiver, uint256 amount){
        if(!etherreceiver.send(amount)){
           throw;
        }
    }

    function sendHell(address _to, uint256 _amount) returns (bool success) {
        if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
            balances[msg.sender] -= _amount;
            hellReceived[_to] += _amount;
            emit SomeoneHatesYou(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function sendHellFrom(address _from, address _to, uint256 _amount) returns (bool success) {
        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0
              && balances[_to] + _amount > balances[_to]) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            hellReceived[_to] += _amount;
            emit SomeoneHatesYou(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }



    /*
     * This modifier is present in some real world token contracts, and due to a solidity
     * bug it was not compatible with multisig wallets
     */
    modifier onlyPayloadSize(uint size) {
        require(msg.data.length == size + 4);
        _;
    }

    /// @dev Transfers sender's tokens to a given address. Returns success.
    /// @param _to Address of token receiver.
    /// @param _value Number of tokens to transfer.
    /// @return Returns success of function call.
    function transfer(address _to, uint256 _amount) returns (bool success) {
        if (balances[msg.sender] >= _amount
            && _amount > 0
            && balances[_to] + _amount > balances[_to]) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            emit Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
    /// @param _from Address from where tokens are withdrawn.
    /// @param _to Address to where tokens are sent.
    /// @param _value Number of tokens to transfer.
    /// @return Returns success of function call.
    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
        if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0
              && balances[_to] + _amount > balances[_to]) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            emit Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    /// @dev Sets approved amount of tokens for spender. Returns success.
    /// @param _spender Address of allowed account.
    /// @param _value Number of approved tokens.
    /// @return Returns success of function call.
    function approve(address _spender, uint256 _value) public returns (bool success){
     if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
      }else{
        return false;
      }
    }

    /// @dev Returns number of allowed tokens for given address.
    /// @param _owner Address of token owner.
    /// @param _spender Address of token spender.
    /// @return Returns remaining allowance for spender.
    function allowance(address _owner, address _spender) constant public returns (uint256 remaining){
        return allowed[_owner][_spender];
    }

    /// @dev Returns number of tokens owned by given address.
    /// @param _owner Address of token owner.
    /// @return Returns balance of owner.
    function balanceOf(address _owner) constant public returns (uint256 balance)
    {
        return balances[_owner];
    }
}
