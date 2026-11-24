## Commit Message
Date: 2026-07-29
Model: claude-sonnet-4-6
Effort: high

### Task
Update Mechanics.jl to UnitTypes v3.0.1 and add tests in TestItems.jl style.

### Progress

**2026-07-29 — Analysis complete, beginning implementation**
- Analyzed codebase: AreaMoments.jl, EulerBeam.jl, Torsion.jl use Unitful types exclusively
- Analyzed UnitTypes v3.0.1 API (Measure.jl, Catchall.jl, SI.jl, Angle.jl, Dimension.jl)
- Key mapping: AbstractLength, AbstractForce, AbstractTorque, AbstractPressure, AbstractAngle
- UnitTypes uses Catchall for dimensional arithmetic; resolves to named types via dimension map lookup
- Must define LinearForce (N/m) and MomentOfInertia (m^4) as new base measures
- Angle-returning formulas need Radian(toBaseFloat(...)) wrapping since angle has {AbstractAngle:1} dims
- Torsion.jl has a duplicate torque() function and uses atan2 (not valid Julia) — both fixed
- uconvert() calls replaced: deflection returns Meter directly via Catchall; angle wrapped as Radian

**2026-07-29 — Implementation**
- Updated Project.toml: removed Unitful/RecipesBase, added TestItemRunner/TestItems to extras/targets
- Updated src/Mechanics.jl: removed Unitful, added TestItems
- Updated src/Units.jl: LinearForce/NewtonPerMeter, MomentOfInertia/Meter4, type aliases, Base.abs
- Updated src/AreaMoments.jl: AbstractLength instead of Unitful.Length
- Updated src/EulerBeam.jl: UnitTypes types, removed uconvert, angle wrapping
- Updated src/Torsion.jl: UnitTypes types, fixed duplicate torque(), atan2→atan, toBaseFloat usage
- Updated test/runtests.jl: TestItemRunner with @run_package_tests
- Converted test/testAreaMoments.jl to @testitem style
- Converted test/testEulerBeam.jl to @testitem style
- Added test/testTorsion.jl with @testitem tests

**2026-07-29 — Debugging and fixes (session 2)**
- Root cause of test errors: KiloNewton stores abstract dims {AbstractForce:1} while Newton stores expanded {AbstractMass:1, AbstractLength:1, AbstractTime:-2}; mixed representations cause Catchall arithmetic to produce unreduced dims
- Fix in EulerBeam.jl fixedFreeDeflectionForce: wrap result as Meter(toBaseFloat(...)) and use toBaseFloat for warning comparison; avoids Catchall type assertion error on return and MethodError on comparison
- Fix in testTorsion.jl: use isapprox(toBaseFloat(T2), toBaseFloat(bar.T), rtol=1e-10) for floating-point near-equal comparison; UnitTypes isapprox defaults rtol=0

### Test command
`julia --project=test test/runtests.jl`

### Final result
43/43 tests pass.

**2026-11-24 — Material models (claude-opus-5-5, effort low)**
- Added src/Materials.jl: AbstractMaterial, IsotropicMaterial (density, elasticModulus, poissonsRatio, optional yield and ultimate strengths, stored in SI as KgPerM3 / Pascal), accessors materialName, density, elasticModulus, poissonsRatio, shearModulus, bulkModulus, yieldStrength, ultimateStrength, and massOf(material, volume)
- Library of typical materials: steel1018, stainless304, aluminum6061, aluminum7075, brass360, titanium6Al4V, pla, absPlastic (abs would shadow Base.abs), petg, nylon66; all in `Mechanics.materials`
- For ImagoForm's `material` body parameter and ImagoDyne's dynamics() (see Plecto/notes/18-dynamicsStudy.md)
- Known blocker: `__precompile__(false)` keeps precompiled packages from loading Mechanics; requested from UnitTypes in UnitTypes.jl/dev/261124_requestsForDynamics.md
- Added test/testMaterials.jl; full suite 90/90 passes

**2026-11-24 — Precompilable Mechanics (claude-opus-5-5, effort low)**
- Meter4 and NewtonPerMeter now come from UnitTypes (local branch dynamicsMeasures, commit bf0e65d); Mechanics devs ../UnitTypes.jl until a release
- Removed the local @makeBaseMeasure / @relateMeasures from src/Units.jl and `__precompile__(false)` from src/Mechanics.jl; Mechanics now loads precompiled
- Code uses AbstractSecondMomentOfArea and AbstractLinearStiffness; MomentOfInertia, AbstractMomentOfInertia, LinearForce, AbstractLinearForce, PolarMomentOfInertia kept as aliases
- Full suite 90/90 passes
- Before release: switch Project.toml/Manifest back to a registered UnitTypes containing these measures and raise the compat bound
