# Second moments of area (area moments of inertia), as a property of a plane area

"""
`areaMomentCircle(r::AbstractLength)`
Given rod radius `r`, returns the area moment about a perpendicular axis located at the rod center with Length^4 units.
"""
function areaMomentCircle(r::AbstractLength)
  return π*r^4/4
end

"""
`areaMomentAnnulus(rA::AbstractLength, rB::AbstractLength)`
Given rod radii `rA` and `rB`, returns the area moment of the annulus about a perpendicular axis located at the rod center with Length^4 units.
"""
function areaMomentAnnulus(rA::AbstractLength, rB::AbstractLength)
  if rA > rB
    return areaMomentCircle(rA) - areaMomentCircle(rB)
  else
    return areaMomentCircle(rB) - areaMomentCircle(rA)
  end
end
