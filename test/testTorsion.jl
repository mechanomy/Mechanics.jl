
@testitem "shapeFactorCircle" begin
  using Mechanics
  using UnitTypes
  @test Mechanics.shapeFactorCircle(Meter(1)) ≈ Meter4(π/2)
  @test Mechanics.shapeFactorCircle(MilliMeter(1000)) ≈ Meter4(π/2)
end

@testitem "shapeFactorSquare" begin
  using Mechanics
  using UnitTypes
  @test Mechanics.shapeFactorSquare(Meter(1)) ≈ Meter4(2.25)
end

@testitem "TorquedCircularBar angle" begin
  using Mechanics
  using UnitTypes
  bar = Mechanics.TorquedCircularBar(
    T=NewtonMeter(10),
    L=Meter(1),
    r=Meter(0.05),
    J=Meter4(π/2*0.05^4),
    G=GigaPascal(80)
  )
  theta = Mechanics.angle(bar)
  @test theta isa AbstractAngle
  expected = Radian(toBaseFloat(bar.T) * toBaseFloat(bar.L) / (toBaseFloat(bar.J) * toBaseFloat(bar.G)))
  @test theta ≈ expected
end

@testitem "TorquedCircularBar shearStress" begin
  using Mechanics
  using UnitTypes
  J = Meter4(π/2*0.05^4)
  bar = Mechanics.TorquedCircularBar(T=NewtonMeter(10), L=Meter(1), r=Meter(0.05), J=J, G=GigaPascal(80))
  tau = Mechanics.shearStress(bar, Meter(0.05))
  @test tau isa AbstractPressure
  tauMax = Mechanics.shearStressMax(bar)
  @test tau ≈ tauMax
end

@testitem "TorquedCircularBar shearEnergy" begin
  using Mechanics
  using UnitTypes
  J = Meter4(π/2*0.05^4)
  bar = Mechanics.TorquedCircularBar(T=NewtonMeter(10), L=Meter(1), r=Meter(0.05), J=J, G=GigaPascal(80))
  U = Mechanics.shearEnergy(bar)
  @test U isa AbstractMeasure
end

@testitem "TorquedNoncircularBar angle and torque" begin
  using Mechanics
  using UnitTypes
  K = toBaseFloat(Mechanics.shapeFactorSquare(Meter(0.05)))
  bar = Mechanics.TorquedNoncircularBar(T=NewtonMeter(10), L=Meter(1), G=GigaPascal(80), K=K)
  theta = Mechanics.angle(bar)
  @test theta isa AbstractAngle
  T2 = Mechanics.torque(bar, theta)
  @test T2 isa AbstractTorque
  @test isapprox(toBaseFloat(T2), toBaseFloat(bar.T), rtol=1e-10)
end

@testitem "shapeFactorTriangleIsoceles domain error" begin
  using Mechanics
  using UnitTypes
  @test_throws DomainError Mechanics.shapeFactorTriangleIsoceles(Meter(1), Meter(10), Meter(10))
end
