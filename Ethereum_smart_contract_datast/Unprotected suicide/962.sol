function SelfDesctructionContract() {
    owner = msg.sender;
}

// you can call it anything you want
function destroyContract() ownerRestricted {
    selfdestruct(owner);
}
