
# 2002_YoungBudynas_RoarksFormulasForStressAndStrain.pdf

# formulas for shape factor K in theta=T*L/K/G, Roark's T10.1
# K has units m^4 (polar moment of inertia)
function shapeFactorCircle(radius::AbstractLength)
  return π/2*radius^4
end
function shapeFactorEllipse(; major::AbstractLength, minor::AbstractLength)
  return (π*major^3*minor^3)/(major^2+minor^2)
end
function shapeFactorSquare(a::AbstractLength)
  return Meter4(2.25*toBaseFloat(a)^4)
end
function shapeFactorRectangle(; a::AbstractLength, b::AbstractLength)
  av = toBaseFloat(a)
  bv = toBaseFloat(b)
  return Meter4(av*bv^3*(16/3 - 3.36*bv/av*(1-bv^4/(12*av^4))))
end
function shapeFactorTriangleEquilateral(a::AbstractLength)
  return Meter4(toBaseFloat(a)^4*sqrt(3)/80)
end

"""
shapeFactorTriangleIsoceles(a::AbstractLength, b::AbstractLength, c::AbstractLength)
For a triangle with equal sides `c` and third side `a`:
  `a` = length of the largest side
  `b` = length between the equal sides between the tip and large side
  `c` = length of the equal sides
Returns shape factor K in m^4.
"""
function shapeFactorTriangleIsoceles(a::AbstractLength, b::AbstractLength, c::AbstractLength) :: AbstractSecondMomentOfArea
  av = toBaseFloat(a)
  bv = toBaseFloat(b)
  if 2/3 < av/bv && av/bv < sqrt(3)
    return Meter4(av^3*bv^3 / (15*av^2 + 20*bv^2))
  end
  if sqrt(3) <= av/bv && av/bv < 2*sqrt(3)
    return Meter4(0.0915*bv^4*(av/bv-0.8592))
  end
  alpha = atan(av/2, bv/2)
  throw(DomainError(alpha, "shapeFactorTriangleIsoceles(a=$a, b=$b, c=$c) has triangle tip angle=$alpha which is not within the formula's 39°-120° range."))
end


# Roark's 10.1 assumptions:
# 1 - bar is straight, uniform circular crosssection
# 2 - loaded only by equal and opposite couples applied at the ends in planes normal to the central axis
# 3 - bar has not exceeded its elastic limit
struct TorquedCircularBar
  T::AbstractTorque
  L::AbstractLength
  r::AbstractLength
  J::AbstractSecondMomentOfArea
  G::AbstractPressure
end
TorquedCircularBar(; T::AbstractTorque, L::AbstractLength, r::AbstractLength, J::AbstractSecondMomentOfArea, G::AbstractPressure) = TorquedCircularBar(T, L, r, J, G)

function angle(bar::TorquedCircularBar) :: AbstractAngle
  return Radian(toBaseFloat(bar.T) * toBaseFloat(bar.L) / (toBaseFloat(bar.J) * toBaseFloat(bar.G)))
end

"""
shear stress in the bar a distance `ρ` from the central axis
> Roark's 10.1-1
"""
function shearStress(bar::TorquedCircularBar, ρ::AbstractLength)
  return bar.T*ρ/bar.J
end
function shearStressMax(bar::TorquedCircularBar)
  return shearStress(bar, bar.r)
end
function shearEnergy(bar::TorquedCircularBar)
  return 0.5 * bar.T^2 * bar.L / bar.J / bar.G
end

# Roark's 10.2 with assumptions
# 1 - bar is straight, uniform noncircular crosssection
# 2 - loaded only by equal and opposite couples applied at the ends in planes normal to the central axis
# 3 - bar has not exceeded its elastic limit
# K is the shape factor in m^4 stored as a Float64
struct TorquedNoncircularBar
  T::AbstractTorque
  L::AbstractLength
  G::AbstractPressure
  K::Real
end
TorquedNoncircularBar(; T::AbstractTorque, L::AbstractLength, G::AbstractPressure, K::Real) = TorquedNoncircularBar(T, L, G, K)

function angle(bar::TorquedNoncircularBar) :: AbstractAngle
  return Radian(toBaseFloat(bar.T) * toBaseFloat(bar.L) / (bar.K * toBaseFloat(bar.G)))
end

"""
Finds the Torque applied to the `bar` that induces `theta`, ignoring `bar.T`.
[Roark's formulas for stress and strain: 10.2-1]
"""
function torque(bar::TorquedNoncircularBar, theta::AbstractAngle) :: AbstractTorque
  return NewtonMeter(theta.value * bar.K * toBaseFloat(bar.G) / toBaseFloat(bar.L))
end
