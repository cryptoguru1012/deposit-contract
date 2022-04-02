// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "hardhat/console.sol";

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract DepositContract {
    uint balance;
    mapping(address => uint)public user_bank;
    mapping(address => uint)public team_bank;
    IERC20 public ETH;

    constructor() {
        ETH = IERC20(0x2170Ed0880ac9A755fd29B2688956BD959F933F8);
    }

    event Deposited();
    event Withdrawed(uint256 number);

    function GetBal() public view returns(uint){
        return(address(this).balance);
    }

    function UserDeposit(uint _amount) public payable{
        ETH.transferFrom(msg.sender, address(this), _amount);
        user_bank[msg.sender] += msg.value;
        balance += msg.value;
        emit Deposited();
    }

    function TeamDeposit(uint _amount) public payable{
        ETH.transferFrom(msg.sender, address(this), _amount);
        team_bank[msg.sender] += msg.value;
        balance += msg.value;
        emit Deposited();
    }

    function Withdraw(uint _amount) public {
        require (user_bank[msg.sender] == _amount, "Insufficent Funds");
        ETH.transfer(
            msg.sender,
            _amount
        );
        user_bank[msg.sender] = 0;
        balance -= _amount;
        emit Withdrawed(_amount);
    }
}