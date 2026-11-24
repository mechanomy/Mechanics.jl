# Material models: the properties a mechanics calculation reads from a material, and a small library of common engineering materials.
# Values are typical room-temperature handbook values (MatWeb, ASM Handbook, supplier data sheets for the polymers); check the grade, temper and supplier before relying on them, and for 3D-printed parts expect lower, direction-dependent strengths.

"""
The supertype of every material model, so functions over materials (a part's mass, a stress check) can dispatch on it.
Every material gives at least `density(m)`.
"""
abstract type AbstractMaterial end

"""
    IsotropicMaterial(name; density, elasticModulus, poissonsRatio, yieldStrength=nothing, ultimateStrength=nothing)

A linear-elastic, isotropic material: the same properties in every direction, described by its `density`, Young's `elasticModulus` and `poissonsRatio`, with the shear modulus following from these as G = E / 2(1 + ν) (Cook and Young, Eq. 1.6-3).
Strengths are optional, `nothing` when unknown.
Quantities are UnitTypes measures, stored in SI.
"""
struct IsotropicMaterial <: AbstractMaterial
  name::String
  density::KgPerM3
  elasticModulus::Pascal
  poissonsRatio::Float64
  yieldStrength::Union{Pascal,Nothing}
  ultimateStrength::Union{Pascal,Nothing}
end

function IsotropicMaterial(name::AbstractString; density::AbstractDensity, elasticModulus::AbstractPressure, poissonsRatio::Real, yieldStrength::Union{AbstractPressure,Nothing}=nothing, ultimateStrength::Union{AbstractPressure,Nothing}=nothing)
  toBaseFloat(density) > 0 || throw(ArgumentError("$name: density must be positive, got $density"))
  toBaseFloat(elasticModulus) > 0 || throw(ArgumentError("$name: elasticModulus must be positive, got $elasticModulus"))
  -1 < poissonsRatio < 0.5 || throw(ArgumentError("$name: poissonsRatio must lie in (-1, 0.5) for a stable isotropic material, got $poissonsRatio"))
  toPascal(x) = x === nothing ? nothing : Pascal(toBaseFloat(x))
  return IsotropicMaterial(String(name), KgPerM3(toBaseFloat(density)), Pascal(toBaseFloat(elasticModulus)), Float64(poissonsRatio), toPascal(yieldStrength), toPascal(ultimateStrength))
end

Base.show(io::IO, m::IsotropicMaterial) = print(io, "IsotropicMaterial(\"", m.name, "\", ρ = ", m.density, ", E = ", m.elasticModulus, ", ν = ", m.poissonsRatio, ")")

"The name of material `m`."
materialName(m::IsotropicMaterial) = m.name
"Mass per unit volume of material `m`."
density(m::IsotropicMaterial) = m.density
"Young's modulus of material `m`, the slope of its stress-strain curve in tension."
elasticModulus(m::IsotropicMaterial) = m.elasticModulus
"Poisson's ratio of material `m`, the lateral contraction per unit axial strain."
poissonsRatio(m::IsotropicMaterial) = m.poissonsRatio
"Shear modulus of isotropic material `m`, G = E / 2(1 + ν) (Cook and Young, Eq. 1.6-3)."
shearModulus(m::IsotropicMaterial) = Pascal(toBaseFloat(m.elasticModulus) / (2 * (1 + m.poissonsRatio)))
"Bulk modulus of isotropic material `m`, K = E / 3(1 − 2ν)."
bulkModulus(m::IsotropicMaterial) = Pascal(toBaseFloat(m.elasticModulus) / (3 * (1 - 2 * m.poissonsRatio)))
"Tensile yield strength of material `m` (0.2% offset for metals), or `nothing` when unknown."
yieldStrength(m::IsotropicMaterial) = m.yieldStrength
"Ultimate tensile strength of material `m`, or `nothing` when unknown."
ultimateStrength(m::IsotropicMaterial) = m.ultimateStrength

"""
    massOf(m::AbstractMaterial, volume::AbstractVolume)

The mass of `volume` of material `m`.
"""
massOf(m::AbstractMaterial, volume::AbstractVolume) = KiloGram(toBaseFloat(density(m)) * toBaseFloat(volume))

# A library of common materials, typical values.
const steel1018 = IsotropicMaterial("AISI 1018 steel, cold drawn"; density=KgPerM3(7870), elasticModulus=GigaPascal(205), poissonsRatio=0.29, yieldStrength=MegaPascal(370), ultimateStrength=MegaPascal(440))
const stainless304 = IsotropicMaterial("304 stainless steel, annealed"; density=KgPerM3(8000), elasticModulus=GigaPascal(193), poissonsRatio=0.29, yieldStrength=MegaPascal(215), ultimateStrength=MegaPascal(505))
const aluminum6061 = IsotropicMaterial("6061-T6 aluminum"; density=KgPerM3(2700), elasticModulus=GigaPascal(68.9), poissonsRatio=0.33, yieldStrength=MegaPascal(276), ultimateStrength=MegaPascal(310))
const aluminum7075 = IsotropicMaterial("7075-T6 aluminum"; density=KgPerM3(2810), elasticModulus=GigaPascal(71.7), poissonsRatio=0.33, yieldStrength=MegaPascal(503), ultimateStrength=MegaPascal(572))
const brass360 = IsotropicMaterial("C360 free-cutting brass, half hard"; density=KgPerM3(8500), elasticModulus=GigaPascal(97), poissonsRatio=0.31, yieldStrength=MegaPascal(310), ultimateStrength=MegaPascal(385))
const titanium6Al4V = IsotropicMaterial("Ti-6Al-4V, annealed"; density=KgPerM3(4430), elasticModulus=GigaPascal(113.8), poissonsRatio=0.342, yieldStrength=MegaPascal(880), ultimateStrength=MegaPascal(950))
const pla = IsotropicMaterial("PLA"; density=KgPerM3(1240), elasticModulus=GigaPascal(3.5), poissonsRatio=0.36, yieldStrength=MegaPascal(50), ultimateStrength=MegaPascal(60))
const absPlastic = IsotropicMaterial("ABS"; density=KgPerM3(1040), elasticModulus=GigaPascal(2.3), poissonsRatio=0.35, yieldStrength=MegaPascal(40), ultimateStrength=MegaPascal(44))
const petg = IsotropicMaterial("PETG"; density=KgPerM3(1270), elasticModulus=GigaPascal(2.1), poissonsRatio=0.38, yieldStrength=MegaPascal(50), ultimateStrength=MegaPascal(53))
const nylon66 = IsotropicMaterial("Nylon 6/6, dry as molded"; density=KgPerM3(1140), elasticModulus=GigaPascal(3.0), poissonsRatio=0.39, yieldStrength=MegaPascal(80), ultimateStrength=MegaPascal(85))

"Every material in the library, by its constant's name."
const materials = (; steel1018, stainless304, aluminum6061, aluminum7075, brass360, titanium6Al4V, pla, absPlastic, petg, nylon66)
