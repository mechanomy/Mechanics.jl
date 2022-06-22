module Mechanics
  # using UnitfulRecipes
  using RecipesBase # plot recipies
  using Unitful, Unitful.DefaultSymbols

  include("Units.jl")

  include("AreaMoments.jl")
  include("EulerBeam.jl")

end
