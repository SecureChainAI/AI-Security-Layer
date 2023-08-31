function calcWinnings(
    FixedPoint.Data playerFrontPercent,
    FixedPoint.Data playerBackPercent,
    FixedPoint.Data sectionPercentSize,
    FixedPoint.Data sectionRadiansSize,
    FixedPoint.Data windowAdjustment,
    FixedPoint.Data sectionOffset,
    FixedPoint.Data potSize
) internal view returns (FixedPoint.Data) {
    FixedPoint.Data memory startIntegrationPoint = sectionOffset.add(
        playerFrontPercent.div(sectionPercentSize).mul(sectionRadiansSize)
    );
    FixedPoint.Data memory endIntegrationPoint = sectionOffset.add(
        playerBackPercent.div(sectionPercentSize).mul(sectionRadiansSize)
    );
    return
        integrate(endIntegrationPoint, windowAdjustment)
            .sub(integrate(startIntegrationPoint, windowAdjustment))
            .mul(potSize)
            .mul(windowAdjustment)
            .div(_2pi);
}
