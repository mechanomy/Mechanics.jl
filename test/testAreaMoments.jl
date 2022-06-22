

@testset "Circle area moment of inertia" begin
  @test Mechanics.areaMomentCircle(1m) == (1m)^4*π/4
end

@testset "Annulus area moment of inertia" begin
  @test Mechanics.areaMomentAnnulus(1m, 2m) == (2m)^4*π/4 - (1m)^4*π/4
end