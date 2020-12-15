//SPDX-License-Identifier:MIT;
pragma solidity ^0.7.0;
import "./Cliente.sol";

contract Inmobiliaria {

    address[] addressContratosClientes;
    address[] addressesPersonalEmpresa;

    address payable public owner;
    address payable public savingAccount;
    address payable public companyToPay;

    bool  isGestorVotingPeriod;
    bool  isGestorPostulationPeriod;

    uint256 montoObjetivoClientes; //In wei
    uint256 commissionPercentage;
    uint256 newClientCommissionPercentage;
    uint256 montoActual; //In wei

    //event LoanEvent(address indexed _saver,  uint _debt);

    mapping(address => Cliente) contratosCliente;

    mapping(address => bool) esPersonalEmpresa;

    constructor()   { 
        owner = msg.sender;
        montoObjetivoClientes = 1000000000000000000000; //1000 eth en wei
        commissionPercentage = 10;
        newClientCommissionPercentage = 5;
        addressesPersonalEmpresa.push(owner);
        esPersonalEmpresa[owner] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier onlyPersonal() {
        require(esPersonalEmpresa[msg.sender] != false, "Only company personnel can call this function.");
        _;
    }

    modifier isContractOwner() {
        require(contratosCliente[msg.sender].hasOwner(), "Only the owner can call this function.");
        _;
    }


    function configureContract( uint256  montoObjetivo ) public onlyPersonal {
        if(montoObjetivo >= 1000){
            //Transformo a wei
            montoObjetivoClientes =  montoObjetivo * 10^18;
        }
    }

    function getBalance() public view onlyPersonal returns(uint256){
        return address(this).balance;
    }

    function getMyContractAddress() public view isContractOwner returns(address){
        return contratosCliente[msg.sender].getAddress(); 
    }

    function getClientBalance(address cliente) public view onlyPersonal returns(uint256){
        return contratosCliente[cliente].getBalance(); 
    }

    function getMyBalance() public view isContractOwner returns(uint256){
        return contratosCliente[msg.sender].getBalance(); 
    }

    function retireFunds(uint256 amount) public onlyPersonal  {
        msg.sender.transfer(amount);
    }


    receive() external payable {
        if(msg.value > 0) {
            if(!contratosCliente[msg.sender].hasOwner() ) { 
                Cliente client = new Cliente(msg.sender, montoObjetivoClientes, address(this));
                contratosCliente[msg.sender] = client; 
                addressContratosClientes.push(msg.sender);
                uint256 amountToTransfer = msg.value /100 * (100 - newClientCommissionPercentage);
                payable(address(client)).transfer(amountToTransfer); 
                uint amountToSavings = msg.value - amountToTransfer;
                montoActual+= amountToSavings;
            } else {
                Cliente client = contratosCliente[msg.sender];
                uint256 amountToTransfer = msg.value /100 * (100 - commissionPercentage);
                payable(address(client)).transfer(amountToTransfer); 
                uint amountToSavings = msg.value - amountToTransfer;
                montoActual+= amountToSavings;
            }
        }
    }

    function destroyClientContract() public isContractOwner {
        if(contratosCliente[msg.sender].getSavingNumber() >= contratosCliente[msg.sender].getObjectiveNumber()){
            contratosCliente[msg.sender].withDrawSavings();
            contratosCliente[msg.sender].close();
        } 
    }

}