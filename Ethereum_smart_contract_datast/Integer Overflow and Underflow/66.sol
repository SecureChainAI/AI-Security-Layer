pragma solidity ^0.4.23;
// Checks input and then creates storage buffer to update a tier's duration
  function updateTierDuration(uint _tier_index, uint _new_duration) internal view {
    // Ensure valid input
    if (_new_duration == 0)
      revert('invalid duration');

    // Get sale start time -
    uint starts_at = uint(Contract.read(SaleManager.startTime()));
    // Get current tier in storage -
    uint current_tier = uint(Contract.read(SaleManager.currentTier()));
    // Get total sale duration -
    uint total_duration = uint(Contract.read(SaleManager.totalDuration()));
    // Get the time at which the current tier will end -
    uint cur_ends_at = uint(Contract.read(SaleManager.currentEndsAt()));
    // Get the current duration of the tier marked for update -
    uint previous_duration
      = uint(Contract.read(SaleManager.tierDuration(_tier_index)));

    // Normalize returned current tier index
    current_tier = current_tier.sub(1); // integer underflow

    // Ensure an update is being performed
    if (previous_duration == _new_duration)
      revert("duration unchanged");
    // Total crowdsale duration should always be minimum the previous duration for the tier to update
    if (total_duration < previous_duration)
      revert("total duration invalid");
    // Ensure tier to update is within range of existing tiers -
    if (uint(Contract.read(SaleManager.saleTierList())) <= _tier_index)
      revert("tier does not exist");
    // Ensure tier to update has not already passed -
    if (current_tier > _tier_index)
      revert("tier has already completed");
    // Ensure the tier targeted was marked as 'modifiable' -
    if (Contract.read(SaleManager.tierModifiable(_tier_index)) == 0)
      revert("tier duration not modifiable");

    Contract.storing();

    // If the tier to update is tier 0, the sale should not have started yet -
    if (_tier_index == 0) {
      if (now >= starts_at)
        revert("cannot modify initial tier once sale has started");

      // Store current tier end time
      Contract.set(SaleManager.currentEndsAt()).to(_new_duration.add(starts_at));
    } else if (_tier_index > current_tier) {
      // If the end time has passed, and we are trying to update the next tier, the tier
      // is already in progress and cannot be updated
      if (_tier_index - current_tier == 1 && now >= cur_ends_at)
        revert("cannot modify tier after it has begun");

      // Loop over tiers in storage and increment end time -
      for (uint i = current_tier + 1; i < _tier_index; i++)
        cur_ends_at = cur_ends_at.add(uint(Contract.read(SaleManager.tierDuration(i))));

      if (cur_ends_at < now)
        revert("cannot modify current tier");
    } else {
      // Not a valid state to update - throw
      revert('cannot update tier');
    }

    // Get new overall crowdsale duration -
    if (previous_duration > _new_duration) // Subtracting from total_duration
      total_duration = total_duration.sub(previous_duration - _new_duration);
    else // Adding to total_duration
      total_duration = total_duration.add(_new_duration - previous_duration);

    // Store updated tier duration
    Contract.set(SaleManager.tierDuration(_tier_index)).to(_new_duration);

    // Update total crowdsale duration
    Contract.set(SaleManager.totalDuration()).to(total_duration);
  }