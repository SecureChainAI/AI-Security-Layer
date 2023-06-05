pragma solidity ^0.4.13;

import "./TokenCore.sol";
import "./mortal.sol";


contract VendorInvoice is LarinToken, Mortal  {
    event InvoiceAdded(address vendor,string title,string invoiceID,uint256 amount,address to);
    event InvoicePaid(address vendor,string title,string invoiceID,uint256 amount,address to);


    struct Invoice {
        string title;
        string invoiceID;
        uint256 amount;
        address to;
        bool isPaid;
        int dueDate;
        bool isEntity;

    }

      // here we store our invoices :
    mapping (address => mapping(string=>Invoice)) internal invoices;



    function addInvoice(address vendor,string title,string invoiceID,uint256 amount,address to,int dueDate){
        invoices[vendor][invoiceID] = Invoice(title,invoiceID,amount,to,false,dueDate,true);
        InvoiceAdded(vendor,title,invoiceID,amount,to);
    }

    function getInvoice(string id,address vendor) public view returns(string title,string invoiceID,uint256 amount,address to,bool isPaid,int dueDate) {
        Invoice invoice = invoices[vendor][id];
        return (invoice.title,invoice.invoiceID,invoice.amount,invoice.to,invoice.isPaid,invoice.dueDate);
    }



    function payInvoice(string invoiceID,address vendor) public payable {
        require(0x0 != msg.sender);
        Invoice invoice = invoices[vendor][invoiceID];
        assert(invoice.isEntity);
        assert(invoice.to == msg.sender && invoice.amount == msg.value);
        transferFrom(msg.sender,vendor,invoice.amount);
        InvoicePaid(vendor,invoice.title,invoice.invoiceID,invoice.amount,msg.sender);
        invoices[vendor][invoiceID].isPaid = true;


    }

    function calculateAndPayShares() {
        // pay the share between stackeholders and stuff;
    }
}
