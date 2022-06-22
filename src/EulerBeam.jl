

"""
`tipDeflection(; P::Unitful.Force=0N, M::Torque=0u"N*m", q::LinearForce=0u"N/m", L::Unitful.Length, E::ElasticModulus, I::MomentOfInertia ) :: Unitful.Length`
Calculates the tip deflection for an Euler beam firmly fixed on one end, subject to:
* `P` -- point force applied `L` from the fixed end
* `M` -- moment acting in the bending plane
* `q` -- linear force acting over the length of the beam
with 
* `E` -- the beam's elastic modulus
* `I` -- the beam's area moment of inertia
returning the deflection perpendicular to the beam length, or parallel to the direction of `P` and `q`.
"""
function tipDeflection(; P::Unitful.Force=0N, M::Torque=0u"N*m", q::LinearForce=0u"N/m", L::Unitful.Length, E::ElasticModulus, I::MomentOfInertia ) :: Unitful.Length
  return M*L^2/(2*E*I) + P*L^3/(3*E*I) + q*L^4/(8*E*I)
end


