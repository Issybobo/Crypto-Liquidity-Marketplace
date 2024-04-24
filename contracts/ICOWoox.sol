// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Woox.sol";

contract ICOWoox {
    address admin;
    Woox public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokenSold;

    event Sell(address _buyer, uint256 _amount);

    constructor (Woox _tokenContract, uint256 _tokenPrice) {
        // UPDATE THE INFORMATION in our state variable
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }
 // multiply function to track the pricing of the token
    function multiply(uint256 x, uint256 y) internal pure returns(uint256 z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    //
    function buyTokens(uint256 _numberOfTokens) public payable {
        //check the value 
        require(msg.value == multiply (_numberOfTokens, tokenPrice));
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens);
        require(tokenContract.transfer(msg.sender, _numberOfTokens * 1000000000000000000));
        
        // increment the number  of token
        tokenSold += _numberOfTokens;

        emit Sell(msg.sender, _numberOfTokens);
    }
 // functtion to end sale is only the admin that can end this contract
    function endSale() public {
        require(msg.sender == admin);
        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))));

        payable(admin).transfer(address(this).balance);
    }
}