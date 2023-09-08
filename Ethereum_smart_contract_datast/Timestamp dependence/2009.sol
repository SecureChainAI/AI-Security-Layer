        if (hasRole(_from, _role, _to) && rolesExpiration[_getRoleSignature(_from, _role, _to)] == _expirationDate) {
        return _timestamp < now;
