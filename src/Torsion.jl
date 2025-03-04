
#formulas for shape factor K in theta=T*L/K/G, Roark's T10.1
function shapeFactorCircle( radius::Length )
  return .5*π*radius^4
end
function shapeFactorEllipse(; major::Length, minor::Length )
  return (π*major^3*minor^3)/(major^2+minor^2)
end
function shapeFactorSquare( a::Length )
  return 2.25*a^4 
end
function shapeFactorRectangle(; a::Length, b::Length)
  return a*b^3*(16/3 - 3.36*b/a*(1-b^4/(12*a^4)))  #for a >> b , Roark T10.1#4
end
function shapeFactorTriangleEquilateral( a::Length )
  return a^4*sqrt(3)/80
end

"""
shapeFactorTriangleIsoceles( a::Length, b::Length, c::Length )
For a triangle with equal sides `c` and third side `a`
  `a` = length of the largest side
  `b` = length between the equal sides between the tip and  large side
  `c` = length of the equal sides
"""
function shapeFactorTriangleIsoceles( a::Length, b::Length, c::Length ) :: Real
  if 2/3 < a/b && a/b < sqrt(3) #tip angle = 39d < a/b < 82d
    return a^3*b^3 / (15*a^2 + 20*b^2) # exact for tip angle = 60d
  end

  if sqrt(3) <= a/b && a/b < 2*sqrt(3) # tip angle = 82d < a/b < 120d
    return 0.0915*b^4*(a/b-0.8592) # exact at tip angle = 90d
  end

  alpha = atan2(a/2, b/2)
  throw( DomainError(alpha, "shapeFactorTriangleIsoceles(a=$a, b=$b, c=$c) has triangle tip angle=$alpha which is not within the formula's 39°-120° range.") )
  return -1 #?
end

# function shapeFactor ...


# ## which is more julian? ####################################################################################################
# # formulas subject to an assumption, nested modules approach
# module TorquedCircularBarModule
#   # Roark's 10.1 assumptions:
#   # 1 - bar is straight, uniform circular crosssection
#   # 2 - loaded only by equal and opposite couples applied at the ends in planes normal to the central axis
#   # 3 - bar has not exceeded its elastic limit
#   """
#   `T` = twisting moment about the beam axis
#   `l` = length
#   `r` = outer radius of the section
#   `J` = polar moment of inertia
#   `G` = modulus of rigidity (elasticity)
#   `U` = shear energy
#   `ρ` = radial distance from the center of the section to any point `q`
#   `θ` = angle of twist [rad]
#   `τ` = shear stress
#   """
#   """
#   > Roark's 10.1-1
#   """
#   function angle(; T::Torque, l::Length, J::PolarMomentOfInertia, G::ShearModulus )
#     return T*l/J/G
#   end
#   """
#   shear stress in the bar a distance `ρ` from the central axis
#   > Roark's 10.1-1
#   """
#   function shearStress(; T::Torque, J::PolarMomentOfInertia, ρ::Length )
#     return T*ρ/J
#   end
#   function shearStressMax(; T::Torque, J::PolarMomentOfInertia, r::Length )
#     return shearStress(T=T, J=J, ρ=r)
#   end
#   function shearEnergy(; T::Torque, J::PolarMomentOfInertia, l::Length, G::ShearModulus )
#     return 0.5 * T^2 * l / J / G 
#   end
#   # #with calls like 
#   # Mechanics.TorquedCircularBarModule.angle( T, l, J, G)
# end

# Roark's 10.1 assumptions:
# 1 - bar is straight, uniform circular crosssection
# 2 - loaded only by equal and opposite couples applied at the ends in planes normal to the central axis
# 3 - bar has not exceeded its elastic limit
# 2 assumes that plane sections remain plane, which is the case for a beam under a pure torque load, able to conform entirely to it.
# When the ends are fixed in some manner, this induces distortion in the beam sections and may necessitate the more advanced formulas of section10.3

struct TorquedCircularBar
  T::Torque
  L::Length
  r::Length #outer radius
  J::PolarMomentOfInertia
  G::ShearModulus
end
TorquedCircularBar(; T::Torque, L::Length, r::Length, J::PolarMomentOfInertia, G::ShearModulus) = TorquedCircularBar(T, L, r, J, G)

function angle( bar::TorquedCircularBar )
  return bar.T*bar.L/bar.J/bar.G
end

"""
shear stress in the bar a distance `ρ` from the central axis
> Roark's 10.1-1
"""
function shearStress( bar::TorquedCircularBar, ρ::Length )
  return bar.T*ρ/bar.J
end
function shearStressMax( bar::TorquedCircularBar ) 
  return shearStress(bar, bar.r)
end
function shearEnergy( bar::TorquedCircularBar )
  return 0.5 * bar.T^2 * bar.L / bar.J / bar.G 
end

# Roark's 10.2 with assumptions
# 1 - bar is straight, uniform noncircular crosssection
# 2 - loaded only by equal and opposite couples applied at the ends in planes normal to the central axis
# 3 - bar has not exceeded its elastic limit
# Discussion is at p382, tables begin at p401
struct TorquedNoncircularBar
  T::Torque
  L::Length
  G::ShearModulus
  K::Real
end
TorquedNoncircularBar(; T::Torque, L::Length, G::ShearModulus, K::Real ) = TorquedNoncircularBar( T, L, G, K ) 


function angle( bar::TorquedNoncircularBar )
  return bar.T * bar.L / bar.K / bar.G
end

"""
  Finds the Torque applied to the `bar` that induces `theta`, ignoring `bar.T`.
  [Roark's formulas for stress and strain: 10.2-1]
"""
function torque( bar::TorquedNoncircularBar, theta::Angle ) :: Torque
  return theta/bar.L * bar.K * bar.G
end
function torque( bar::TorquedNoncircularBar, theta::Angle ) :: Torque
  T = theta/bar.L * bar.K * bar.G
  return TorquedNoncircularBar(T=T, L=bar.L, G=bar.G, K=bar.K)
end


