    uint pps = value.div(scheme.shares);
    vault.value = vault.value.add(value.sub(pps.mul(scheme.shares)));
 uint tickets = _value.div(regularTicketPrice());
    uint excess = _value.sub(tickets.mul(regularTicketPrice()));
    uint goldenTickets = value.div(Utils.goldenTicketPrice(totalPot));
