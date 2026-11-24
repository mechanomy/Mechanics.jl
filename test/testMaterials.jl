@testitem "IsotropicMaterial construction and accessors" begin
  using Mechanics
  using UnitTypes
  m = Mechanics.IsotropicMaterial("test"; density=KgPerM3(2000), elasticModulus=GigaPascal(100), poissonsRatio=0.25, yieldStrength=MegaPascal(200))
  @test Mechanics.density(m) isa KgPerM3
  @test toBaseFloat(Mechanics.density(m)) ≈ 2000
  @test toBaseFloat(Mechanics.elasticModulus(m)) ≈ 100e9
  @test Mechanics.poissonsRatio(m) == 0.25
  @test toBaseFloat(Mechanics.yieldStrength(m)) ≈ 200e6
  @test Mechanics.ultimateStrength(m) === nothing
  @test Mechanics.materialName(m) == "test"
end

@testitem "Isotropic elastic constants follow from E and ν" begin
  using Mechanics
  using UnitTypes
  m = Mechanics.IsotropicMaterial("test"; density=KgPerM3(2000), elasticModulus=GigaPascal(100), poissonsRatio=0.25)
  G = toBaseFloat(Mechanics.shearModulus(m))
  K = toBaseFloat(Mechanics.bulkModulus(m))
  @test G ≈ 40e9 # E / 2(1+ν)
  @test K ≈ 100e9 / 1.5 # E / 3(1-2ν)
  @test 9 * K * G / (3K + G) ≈ 100e9 # E recovered from K and G
end

@testitem "IsotropicMaterial rejects unphysical values" begin
  using Mechanics
  using UnitTypes
  @test_throws ArgumentError Mechanics.IsotropicMaterial("bad"; density=KgPerM3(-1), elasticModulus=GigaPascal(1), poissonsRatio=0.3)
  @test_throws ArgumentError Mechanics.IsotropicMaterial("bad"; density=KgPerM3(1), elasticModulus=GigaPascal(1), poissonsRatio=0.5)
  @test_throws TypeError Mechanics.IsotropicMaterial("bad"; density=2000, elasticModulus=GigaPascal(1), poissonsRatio=0.3)
end

@testitem "Mass of a volume of material" begin
  using Mechanics
  using UnitTypes
  steelCube = Mechanics.massOf(Mechanics.steel1018, Meter3(1e-6)) # a 1 cm cube
  @test steelCube isa KiloGram
  @test toBaseFloat(steelCube) ≈ 7.87e-3
end

@testitem "Material library" begin
  using Mechanics
  using UnitTypes
  @test length(Mechanics.materials) == 10
  for m in Mechanics.materials
    @test m isa Mechanics.AbstractMaterial
    @test 900 < toBaseFloat(Mechanics.density(m)) < 9000
    @test toBaseFloat(Mechanics.ultimateStrength(m)) >= toBaseFloat(Mechanics.yieldStrength(m))
  end
  @test toBaseFloat(Mechanics.density(Mechanics.aluminum6061)) ≈ 2700
end
