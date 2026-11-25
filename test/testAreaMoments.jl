
@testitem "areaMomentCircle" begin
  using Mechanics
  using UnitTypes
  @test Mechanics.areaMomentCircle(Meter(1)) ≈ Meter4(π/4)
  @test Mechanics.areaMomentCircle(MilliMeter(1000)) ≈ Meter4(π/4)
end

@testitem "areaMomentAnnulus" begin
  using Mechanics
  using UnitTypes
  @test Mechanics.areaMomentAnnulus(Meter(1), Meter(2)) ≈ Meter4((2.0)^4*π/4 - (1.0)^4*π/4)
  @test Mechanics.areaMomentAnnulus(Meter(2), Meter(1)) ≈ Meter4((2.0)^4*π/4 - (1.0)^4*π/4)
end
