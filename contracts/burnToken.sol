pragma solidity 0.4.8;

contract burnToken {

      function totalSupply() public constant returns (uint);

      function balanceOf(address tokenOwner) public constant returns (uint balance);

      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);

      function approve(address spender, uint tokens) public returns (bool success);

      function create(address spender, uint tokens) public returns (bool success);

      function burn(address receiver, uint tokens) public returns (bool success);

      event Burned(address indexed from, address indexed to, uint tokens);

      event Created(address indexed to, uint tokens);

      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}
