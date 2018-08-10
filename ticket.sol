pragma solidity ^0.4.21;

// Create a ticket sale contract
// There are a finite amount of tickets
// Tickets cost ether
// The sale is only open for 3 minutes
// The admin can open and close the sale
// Users can see if the tickets are available
// Can purchase by sending ether to the contract
// Purchases are tracked in the contract and to be validated later
// CanIGoToDevCon: Spoilers
// doIHaveTicket

contract TicketSale {

  enum SaleStatus {
    PENDING, OPEN, CLOSED
  }

  uint public totalTickets;
  uint public ticketPrice;
  uint public ticketsSold;
  uint public saleLasts;
  mapping(address => bool) public ticketHolder;

  address ticketSeller;
  SaleStatus status;
  uint saleStarted;


  constructor(uint ticketSupply, uint ticketCost, uint minutesOpen) public {
    totalTickets = ticketSupply;
    ticketPrice = ticketCost;
    ticketsSold = 0;
    saleLasts = minutesOpen;

    ticketSeller = msg.sender;
    status = SaleStatus.PENDING;
  }

  modifier isAdmin() {
    require(msg.sender == ticketSeller, 'Only the ticket seller can do this');
    _;
  }

  function openSale() public isAdmin {
    status = SaleStatus.OPEN;
    saleStarted = now;
  }

  function closeSale() public isAdmin {
    status = SaleStatus.CLOSED;
  }

  modifier canBuyTickets() {
    require(status == SaleStatus.OPEN, 'Ticket sale is not open');
    require(now <= saleStarted + saleLasts * 1 minutes, 'Ticket sale ended');
    require(ticketsSold < totalTickets, 'No more tickets left');
    _;
  }

  function () public payable canBuyTickets {
    ticketHolder[msg.sender] = true;
    ticketsSold++;
  }

  function areTicketsAvailable() public view returns(bool) {
    return  status == SaleStatus.OPEN &&
      now <= saleStarted + saleLasts * 1 minutes &&
      ticketsSold < totalTickets;
  }

  function doIHaveTicket() public view returns(bool) {
    return ticketHolder[msg.sender];
  }

  function CanIGoToDevCon()  public pure returns(bool) {
    return false;
  }
}

