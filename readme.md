# Mechanics.jl
Functions and structures related to solid mechanics.

The goal of this module is to make mechanics methods easier to use in engineering calculations.
'Ease' has a number of aspects which influence the design of this module:
* functions should be literal and descriptive, to aid discovery, use, recall, and later readers
* arguments should be specifically typed, with preference given to keyword arguments
* theoretical assumptions are included as tests
<!--* symbolics are first-class; every equation has a symbolic analogue -->

See also our [Materials.jl](https://github.com/mechanomy/Materials.jl) package.

This module is very much work-in-progress, at present developed only according to our needs.
Pull-requests welcome, but given the immaturity not really anticipated.

## Install
`using Pkg; Pkg.add(url="https://github.com/mechanomy/Mechanics.jl.git#main")`

## Use
Most functions are not exported, to avoid cluttering your namespace.
Instead, access functions by:
`Mechanics.areaMomentCircle( .. )`
`Mechanics.tipDeflection( .. )`

See [test*.jl](test/) for basic usage of various functions and structures.

## References
> "Roark's Formulas for Stress and Strain", Warren C. Young and Richard G. Budynas, 7th Ed, 2002, [0-07-072542-X](https://archive.org/details/RoarksFormulasForStressAndStrain7thEd/page/n227/mode/2up)
> "Advanced Mechanics of Materials", Robert D. Cook and Warren C. Young, 2nd Ed, 1999, [0-13-396961-4](https://www.pearson.com/store/p/advanced-mechanics-of-materials/P100000832234/9780133969610)
> "Mechanics of Materials", Ferdinand P. Beer, E. Russell Johnson, John T. DeWolf, 4th Ed, 2006, [0-07-298090-7](https://www.google.com/search?tbm=bks&q=0-07-298090-7)


## Other Mechanics-related Packages
* [AD4SM](https://juliapackages.com/p/ad4sm) -- Automatic Differentiation 4 Solid Mechanics

## Disclaimer
As stated in the [license](license.md), no warranty, certification, suitability for use, or other claim to accuracy is made on the contents of this module.
It remains the duty of any user to ensure that any analysis they perform is correct.

## Copyright
Copyright (c) 2022 Mechanomy LLC
