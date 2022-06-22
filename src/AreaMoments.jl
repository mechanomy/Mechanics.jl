# These are area or second moments of inertia, as a property of a plane area

# export areaMomentCircle
"""
`areaMomentCircle(r::Unitful.Length)`
Given rod radius `r`, returns the area moment about a perpendicular axis located at the rod center with Length^4 units.
"""
function areaMomentCircle(r::Unitful.Length)
  return π*r^4/4
end

"""
`areaMomentAnnulus(rA::Unitful.Length, rB::Unitful.Length)`
Given rod radii `rA` and `rB`, returns the area moment of the annulus about a perpendicular axis located at the rod center with Length^4 units.
"""
function areaMomentAnnulus(rA::Unitful.Length, rB::Unitful.Length)
  if rA > rB
    return areaMomentCircle(rA) - areaMomentCircle(rB)
  else
    return areaMomentCircle(rB) - areaMomentCircle(rA)
  end
end
