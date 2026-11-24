# Unit definitions and aliases for Mechanics.jl, built on UnitTypes v3

# Type aliases for common physical dimensions
const Length = AbstractLength
const Force = AbstractForce
const Torque = AbstractTorque
const Angle = AbstractAngle
const ElasticModulus = AbstractPressure
const ShearModulus = AbstractPressure

# LinearForce: force per unit length, N/m; NewtonPerMeter is defined by UnitTypes under AbstractLinearStiffness
const LinearForce = AbstractLinearStiffness
const AbstractLinearForce = AbstractLinearStiffness

# MomentOfInertia: second moment of area, m^4; Meter4 is defined by UnitTypes under AbstractAreaMomentOfInertia
const MomentOfInertia = AbstractAreaMomentOfInertia
const AbstractMomentOfInertia = AbstractAreaMomentOfInertia

# PolarMomentOfInertia shares the same dimension as MomentOfInertia
const PolarMomentOfInertia = AbstractAreaMomentOfInertia

# abs for AbstractMeasure types (not provided by UnitTypes)
Base.abs(x::T) where T<:AbstractMeasure = x.value >= 0 ? x : -x
