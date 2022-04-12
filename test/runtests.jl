using Documenter
using BEFWM2
using Test

# Run doctests first.
DocMeta.setdocmeta!(BEFWM2, :DocTestSetup, :(using BEFWM2); recursive=true)
doctest(BEFWM2)

include("inputs/test-biological_rates.jl")