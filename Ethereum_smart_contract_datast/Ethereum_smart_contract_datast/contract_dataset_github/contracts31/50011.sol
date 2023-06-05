pragma solidity ^0.6.0;
import "./Item.sol";
contract ItemManager {

 struct S_Item {
 Item _item;
 ItemManager.SupplyChainSteps _step;
 string _identifier;
 }
 mapping(uint => S_Item) public items;
 uint index;

 enum SupplyChainSteps {Created, Paid, Delivered}

 event SupplyChainStep(uint _itemIndex, uint _step, address _address);

 function createItem(string memory _identifier, uint _priceInWei) public {
 Item item = new Item(this, _priceInWei, index);
 items[index]._item = item;
 items[index]._step = SupplyChainSteps.Created;
 items[index]._identifier = _identifier;
 emit SupplyChainStep(index, uint(items[index]._step), address(item));
 index++;
 }

 function triggerPayment(uint _index) public payable {
 Item item = items[_index]._item;
 require(address(item) == msg.sender, "Only items are allowed to update themselves"
);
 require(item.priceInWei() == msg.value, "Not fully paid yet");
 require(items[index]._step == SupplyChainSteps.Created, "Item is further in the su
pply chain");
 items[_index]._step = SupplyChainSteps.Paid;
 emit SupplyChainStep(_index, uint(items[_index]._step), address(item));
 }

 function triggerDelivery(uint _index) public {
 require(items[_index]._step == SupplyChainSteps.Paid, "Item is further in the supp
ly chain");
 items[_index]._step = SupplyChainSteps.Delivered;
 emit SupplyChainStep(_index, uint(items[_index]._step), address(items[_index]._ite
m));
 }
}