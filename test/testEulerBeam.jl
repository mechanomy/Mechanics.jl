M = 1u"N*m"
L = 1m
E = 1u"GPa"
I = 1u"m^4"
P = 1u"N"
q = 0.1u"N/m"

@testset "Tip deflection" begin
  @test Mechanics.fixedFreeTipDeflection(M=M, P=P, q=q, L=L, E=E, I=I) == M*L^2/(2*E*I) + P*L^3/(3*E*I) + q*L^4/(8*E*I)
end

@testset "fixedFreeDeflectionForce" begin
  @test typeof( Mechanics.fixedFreeDeflectionForce( E=E, I=I, P=P, L=L ) ) <: Mechanics.Length # with xP unspecified, should not error
  @test_logs (:warn,"Beam deflection is large (-3.3333333333333335 m), likely exceeds the assumptions of an Euler beam.") Mechanics.fixedFreeDeflectionForce(E=E, I=I, P=10000000u"kN", L=L) 
  @test Mechanics.fixedFreeDeflectionForce( E=E, I=I, P=P, L=L ) ≈ -P*L^3/3/E/I
  @test Mechanics.fixedFreeDeflectionForce( E=E, I=I, P=P, L=L, xP=L ) ≈ -P*L^3/3/E/I
  @test Mechanics.fixedFreeDeflectionForce( E=E, I=I, P=P, L=L, xP=0u"m" ) ≈ 0u"m"
  @test Mechanics.fixedFreeDeflectionForce( E=E, I=I, P=0u"N", L=L ) ≈ 0u"m"
  @test Mechanics.fixedFreeDeflectionForce( E=E, I=I, P=P, L=L ) ≈ -Mechanics.fixedFreeDeflectionForce( E=E, I=I, P=-P, L=L )  
  # @show isapprox( Mechanics.fixedFreeDeflectionForce( E=E, I=I, P=P, L=L, xP=L/2 ), -0.1041, rtol=1e-3 )
end

@testset "fixedFreeAngleForce" begin
  @test typeof( Mechanics.fixedFreeAngleForce(E=E, I=I, P=P, L=L) ) <: Mechanics.Angle
  @test_logs (:warn, "Beam deflection angle is large (-5.0 rad), likely exceeds the assumptions of an Euler beam." ) Mechanics.fixedFreeAngleForce(E=E, I=I, P=10000000u"kN", L=L) 
  @test Mechanics.fixedFreeAngleForce(E=E, I=I, P=P, L=L) ≈ -P*L^2/(2*E*I)
  @test Mechanics.fixedFreeAngleForce(E=E, I=I, P=P, L=L, xP=L) ≈ -P*L^2/(2*E*I)
  @test Mechanics.fixedFreeAngleForce(E=E, I=I, P=P, L=L, xP=0u"m") ≈ 0°
  @test Mechanics.fixedFreeAngleForce(E=E, I=I, P=0u"N", L=L, xP=L) ≈ 0°
end

@testset "fixedFreeDeflectionMoment" begin
  @test typeof( Mechanics.fixedFreeDeflectionMoment( E=E, I=I, M=M, L=L ) ) <: Mechanics.Length # with xP unspecified, should not error
  @test_logs (:warn,"Beam deflection is large (-0.5 m), likely exceeds the assumptions of an Euler beam.") Mechanics.fixedFreeDeflectionMoment(E=E, I=I, M=1e9u"N*m", L=L) 
  @test Mechanics.fixedFreeDeflectionMoment( E=E, I=I, M=M, L=L ) ≈ -M*L^2/2/E/I
  @test Mechanics.fixedFreeDeflectionMoment( E=E, I=I, M=M, L=L, x=L ) ≈ -M*L^2/2/E/I
  @test Mechanics.fixedFreeDeflectionMoment( E=E, I=I, M=M, L=L, x=0u"m" ) ≈ 0u"m"
  @test Mechanics.fixedFreeDeflectionMoment( E=E, I=I, M=0u"N*m", L=L ) ≈ 0u"m"
  @test Mechanics.fixedFreeDeflectionMoment( E=E, I=I, M=M, L=L ) ≈ -Mechanics.fixedFreeDeflectionMoment( E=E, I=I, M=-M, L=L )  
  # @show isapprox( Mechanics.fixedFreeDeflectionMoment( E=E, I=I, M=P, L=L, xP=L/2 ), -0.1041, rtol=1e-3 )
end

@testset "fixedFreeAngleMoment" begin
  @test typeof( Mechanics.fixedFreeAngleMoment(E=E, I=I, M=M, L=L) ) <: Mechanics.Angle
  @test_logs (:warn, "Beam deflection angle is large (-1.0 rad), likely exceeds the assumptions of an Euler beam." ) Mechanics.fixedFreeAngleMoment(E=E, I=I, M=1e9u"N*m", L=L) 
  @test Mechanics.fixedFreeAngleMoment(E=E, I=I, M=M, L=L) ≈ -M*L/(E*I)
  @test Mechanics.fixedFreeAngleMoment(E=E, I=I, M=M, L=L, x=L) ≈ -M*L/(E*I)
  @test Mechanics.fixedFreeAngleMoment(E=E, I=I, M=M, L=L, x=0u"m") ≈ 0°
  @test Mechanics.fixedFreeAngleMoment(E=E, I=I, M=0u"N*m", L=L, x=L) ≈ 0°
end


