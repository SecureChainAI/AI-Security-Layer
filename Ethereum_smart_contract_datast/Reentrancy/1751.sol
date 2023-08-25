function proxy(address target, bytes data) public payable {
    target.call.value(msg.value)(data);
}
