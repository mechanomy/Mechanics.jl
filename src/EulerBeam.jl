

"""
`fixedFreeTipDeflection(; P::Force=0N, M::Torque=0u"N*m", q::LinearForce=0u"N/m", L::Length, E::ElasticModulus, I::MomentOfInertia ) :: Length`
Calculates the tip deflection for an Euler beam firmly fixed on one end, subject to:
* `P` -- point force applied `L` from the fixed end
* `M` -- moment acting in the bending plane
* `q` -- linear force acting over the length of the beam
with 
* `E` -- the beam's elastic modulus
* `I` -- the beam's area moment of inertia
returning the deflection perpendicular to the beam length, or parallel to the direction of `P` and `q`.
> Cook&Young figure 1.7-1
> Beer&Johnson Appendix D, by superposition 
"""
function fixedFreeTipDeflection(; P::Force=0N, M::Torque=0u"N*m", q::LinearForce=0u"N/m", L::Length, E::ElasticModulus, I::MomentOfInertia ) :: Length
  return M*L^2/(2*E*I) + P*L^3/(3*E*I) + q*L^4/(8*E*I)
end

# function fixedFreeTipDeflection_viz()
# @series begin
#  draw unloaded beam
#  draw deflected
#  draw loads
# end
# or make an EulerBeam type with a plot recipe?



function fixedFreeDeflection(; P::Force=0N,  M::Torque=0u"N*m", q::LinearForce=0u"N/m", L::Length, xP::Length=L, E::ElasticModulus, I::MomentOfInertia ) :: Length
  return fixedFreeDeflectionForce(E=E, I=I, P=P, L=L, xP=xP)
end

"""
`fixedFreeDeflectionForce(; E::ElasticModulus, I::MomentOfInertia, P::Force=0N, L::Length, xP::Length=L  ) :: Length`
Returns the deflection of the deflected tip from horizontal from applying `P` at `xP`.
`P` is assumed to be applied perpendicular to the beam length `L`.
> Beer&Johnson Appendix D.3
"""
function fixedFreeDeflectionForce(; E::ElasticModulus, I::MomentOfInertia, P::Force=0N, L::Length, xP::Length=L  ) :: Length
  # if L <= 0 ..I'd rather shove this into the type...
  # end
  ret = uconvert(unit(L), P/(6*E*I) * (xP^3 - 3*L*xP^2) )
  if abs(ret) > L*0.1
   @warn "Beam deflection is large ($ret), likely exceeds the assumptions of an Euler beam."
  end
  return ret
end

"""
`fixedFreeAngleForce(; E::ElasticModulus, I::MomentOfInertia, P::Force=0N, L::Length, xP::Length=L  ) :: Angle`
Returns the angle of the deflected tip from horizontal from applying `P` at `xP`.
`P` is assumed to be applied perpendicular to the beam length `L`.
> Beer&Johnson Appendix D.3
"""
function fixedFreeAngleForce(; E::ElasticModulus, I::MomentOfInertia, P::Force=0N, L::Length, xP::Length=L  ) :: Angle
  ret = uconvert(u"rad", P/(2*E*I) * (xP^2 - 2*xP*L) ) #apply radian 
  if abs(ret) > 10u"°" #guardrail..
   @warn "Beam deflection angle is large ($ret), likely exceeds the assumptions of an Euler beam."
  end
  return ret
end


"""
`fixedFreeDeflectionMoment(; E::ElasticModulus, I::MomentOfInertia, M::Moment=0u"N*m", L::Length, x::Length=L) :: Length`
> Beer&Johnson Appendix D.3
"""
function fixedFreeDeflectionMoment(; E::ElasticModulus, I::MomentOfInertia, M::Moment=0u"N*m", L::Length, x::Length=L) :: Length
  # if L <= 0 ..I'd rather shove this into the type...
  # end
  ret = uconvert(unit(L), -M/(2*E*I) * x^2 ) 
  if abs(ret) > L*0.1
   @warn "Beam deflection is large ($ret), likely exceeds the assumptions of an Euler beam."
  end
  return ret
end

"""
`fixedFreeAngleMoment(; E::ElasticModulus, I::MomentOfInertia, M::Moment=0u"N*m", L::Length, x::Length=L) :: Angle`
> Beer&Johnson Appendix D.3
"""
function fixedFreeAngleMoment(; E::ElasticModulus, I::MomentOfInertia, M::Moment=0u"N*m", L::Length, x::Length=L) :: Angle
  # if L <= 0 ..I'd rather shove this into the type...
  # end
  ret = uconvert(u"rad", -M/(E*I) * x ) 
  if abs(ret) > 10u"°"
   @warn "Beam deflection angle is large ($ret), likely exceeds the assumptions of an Euler beam."
  end
  return ret
end

