
@testitem "fixedFreeTipDeflection" begin
  using Mechanics
  using UnitTypes
  M = NewtonMeter(1)
  L = Meter(1)
  E = GigaPascal(1)
  I = Meter4(1)
  P = Newton(1)
  q = NewtonPerMeter(0.1)
  result = Mechanics.fixedFreeTipDeflection(M=M, P=P, q=q, L=L, E=E, I=I)
  expected = M*L^2/(2*E*I) + P*L^3/(3*E*I) + q*L^4/(8*E*I)
  @test result ≈ expected
end

@testitem "fixedFreeDeflectionForce" begin
  using Mechanics
  using UnitTypes
  L = Meter(1)
  E = GigaPascal(1)
  I = Meter4(1)
  P = Newton(1)
  @test typeof(Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=P, L=L)) <: Mechanics.Length
  @test_logs (:warn, "Beam deflection is large (-3.3333333333333335m), likely exceeds the assumptions of an Euler beam.") Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=KiloNewton(10000000), L=L)
  @test Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=P, L=L) ≈ -P*L^3/3/E/I
  @test Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=P, L=L, xP=L) ≈ -P*L^3/3/E/I
  @test Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=P, L=L, xP=Meter(0)) ≈ Meter(0)
  @test Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=Newton(0), L=L) ≈ Meter(0)
  @test Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=P, L=L) ≈ -Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=Newton(-1), L=L)
end

@testitem "fixedFreeAngleForce" begin
  using Mechanics
  using UnitTypes
  L = Meter(1)
  E = GigaPascal(1)
  I = Meter4(1)
  P = Newton(1)
  @test typeof(Mechanics.fixedFreeAngleForce(E=E, I=I, P=P, L=L)) <: Mechanics.Angle
  @test_logs (:warn, "Beam deflection angle is large (-5.0rad), likely exceeds the assumptions of an Euler beam.") Mechanics.fixedFreeAngleForce(E=E, I=I, P=KiloNewton(10000000), L=L)
  @test Mechanics.fixedFreeAngleForce(E=E, I=I, P=P, L=L) ≈ Radian(-toBaseFloat(P*L^2/(2*E*I)))
  @test Mechanics.fixedFreeAngleForce(E=E, I=I, P=P, L=L, xP=L) ≈ Radian(-toBaseFloat(P*L^2/(2*E*I)))
  @test Mechanics.fixedFreeAngleForce(E=E, I=I, P=P, L=L, xP=Meter(0)) ≈ Degree(0)
  @test Mechanics.fixedFreeAngleForce(E=E, I=I, P=Newton(0), L=L, xP=L) ≈ Degree(0)
end

@testitem "fixedFreeDeflectionMoment" begin
  using Mechanics
  using UnitTypes
  M = NewtonMeter(1)
  L = Meter(1)
  E = GigaPascal(1)
  I = Meter4(1)
  @test typeof(Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=M, L=L)) <: Mechanics.Length
  @test_logs (:warn, "Beam deflection is large (-0.5m), likely exceeds the assumptions of an Euler beam.") Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=NewtonMeter(1e9), L=L)
  @test Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=M, L=L) ≈ Meter(-toBaseFloat(M*L^2/2/E/I))
  @test Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=M, L=L, x=L) ≈ Meter(-toBaseFloat(M*L^2/2/E/I))
  @test Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=M, L=L, x=Meter(0)) ≈ Meter(0)
  @test Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=NewtonMeter(0), L=L) ≈ Meter(0)
  @test Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=M, L=L) ≈ -Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=NewtonMeter(-1), L=L)
end

@testitem "fixedFreeAngleMoment" begin
  using Mechanics
  using UnitTypes
  M = NewtonMeter(1)
  L = Meter(1)
  E = GigaPascal(1)
  I = Meter4(1)
  @test typeof(Mechanics.fixedFreeAngleMoment(E=E, I=I, M=M, L=L)) <: Mechanics.Angle
  @test_logs (:warn, "Beam deflection angle is large (-1.0rad), likely exceeds the assumptions of an Euler beam.") Mechanics.fixedFreeAngleMoment(E=E, I=I, M=NewtonMeter(1e9), L=L)
  @test Mechanics.fixedFreeAngleMoment(E=E, I=I, M=M, L=L) ≈ Radian(-toBaseFloat(M*L/(E*I)))
  @test Mechanics.fixedFreeAngleMoment(E=E, I=I, M=M, L=L, x=L) ≈ Radian(-toBaseFloat(M*L/(E*I)))
  @test Mechanics.fixedFreeAngleMoment(E=E, I=I, M=M, L=L, x=Meter(0)) ≈ Degree(0)
  @test Mechanics.fixedFreeAngleMoment(E=E, I=I, M=NewtonMeter(0), L=L, x=L) ≈ Degree(0)
end
