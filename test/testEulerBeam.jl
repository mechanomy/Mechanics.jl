
@testset "Tip deflection" begin
  M = 1u"N*m"
  L = 1m
  E = 1u"GPa"
  I = 1u"m^4"
  P = 1u"N"
  q = 0.1u"N/m"
  @test Mechanics.tipDeflection(M=M, P=P, q=q, L=L, E=E, I=I) == M*L^2/(2*E*I) + P*L^3/(3*E*I) + q*L^4/(8*E*I)
end