//SPDX-License-Identifier:MIT;
pragma solidity ^0.7.0;
 
contract Cliente {
    
    address payable  owner;   
    bool  public exist;
    uint256 objetivo; //In Wei
    address payable inmobiliariaAddres;
    uint256 actualSavings; //In Wei
    uint commissionInmobiliaria;

    constructor( address payable _ownerAddress, uint256 _objetivo, address payable _inmobiliariaAddress )  {
        owner = _ownerAddress;
        exist = true;
        objetivo = _objetivo;
        inmobiliariaAddres = _inmobiliariaAddress;
        actualSavings = 0;
        commissionInmobiliaria = 5;
    }

    modifier isOwnerOrInmobiliaria() {
        require(msg.sender == owner || msg.sender == inmobiliariaAddres, "Only the owner or inmobiliaria can call this function.");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner , "Only the owner or inmobiliaria can call this function.");
        _;
    }

    modifier objectiveAccomplished() {
        require(actualSavings >= objetivo, "You can only withdraw the funds if the objective was accomplished.");
        _;
    }

    function hasOwner() public view  returns(bool){
        return exist;
    }

    function getBalance() public view  isOwnerOrInmobiliaria returns(uint256){
        return address(this).balance;
    }

    function getAddress() public view  returns(address){
        return address(this);
    }

    receive() external payable {
       if(msg.value > 0) {
                uint256 amountToTransfer = msg.value /100 * (commissionInmobiliaria);
                inmobiliariaAddres.transfer(amountToTransfer); 
                actualSavings+= (msg.value - amountToTransfer);
        }
    }

    function withDrawSavings() public onlyOwner objectiveAccomplished {
        msg.sender.transfer(actualSavings);
        close();
    }

    function close() internal { 
        exist = false;
        selfdestruct(address(this)); 
    }
}