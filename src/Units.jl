# Add conventional unit definitions


# SI-related
Length = Unitful.Length
Force = Unitful.Force
@derived_dimension Radian dimension(u"rad")
@derived_dimension Degree dimension(2*pi)
@derived_dimension Torque dimension(u"N*m")
@derived_dimension Moment dimension(u"N*m")
@derived_dimension LinearForce dimension(u"N/m")
@derived_dimension Pascal dimension(u"Pa")
@derived_dimension ElasticModulus dimension(u"GPa")
@derived_dimension ShearModulus dimension(u"GPa")
@derived_dimension MomentOfInertia dimension(u"m^4")
@derived_dimension Density dimension(u"kg/m^3")
# @unit deg "deg" Degree 360/2*pi false
Angle{T} = Union{Quantity{T,NoDims,typeof(u"rad")}, Quantity{T,NoDims,typeof(u"°")}} where T

#introduce a strictly-positive Real? then make unions for Radius, Length, ..?

# Imperial