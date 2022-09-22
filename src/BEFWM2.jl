module BEFWM2

# Dependencies
import DifferentialEquations.Rodas4
import DifferentialEquations.SSRootfind
import DifferentialEquations.Tsit5
using DiffEqBase
using DiffEqCallbacks
using EcologicalNetworks
using Mangal
using OrderedCollections
using SparseArrays
using Statistics

# Include scripts
include(joinpath(".", "macros.jl"))
include(joinpath(".", "inputs/foodwebs.jl"))
include(joinpath(".", "inputs/nontrophic_interactions.jl"))
include(joinpath(".", "inputs/functional_response.jl"))
include(joinpath(".", "inputs/biological_rates.jl"))
include(joinpath(".", "inputs/environment.jl"))
include(joinpath(".", "model/model_parameters.jl"))
include(joinpath(".", "model/productivity.jl"))
include(joinpath(".", "model/consumption.jl"))
include(joinpath(".", "model/metabolic_loss.jl"))
include(joinpath(".", "model/dbdt.jl"))
include(joinpath(".", "model/simulate.jl"))
include(joinpath(".", "model/effect_nti.jl"))
include(joinpath(".", "measures/structure.jl"))
include(joinpath(".", "measures/functioning.jl"))
include(joinpath(".", "measures/stability.jl"))
include(joinpath(".", "utils.jl"))

# Export public functions
export @check_between
export @check_greater_than
export @check_in
export @check_lower_than
export @check_size
export A_competition_full
export A_facilitation_full
export A_interference_full
export A_refuge_full
export allometric_rate
export AllometricParams
export BioEnergeticFunctionalResponse
export BioenergeticResponse
export BioRates
export cascademodel
export ClassicResponse
export coefficient_of_variation
export connectance
export DefaultGrowthParams
export DefaultMaxConsumptionParams
export DefaultMetabolismParams
export draw_asymmetric_links
export draw_symmetric_links
export Environment
export find_steady_state
export FoodWeb
export foodweb_evenness
export foodweb_richness
export foodweb_shannon
export foodweb_simpson
export FunctionalResponse
export FunctionalResponse
export homogeneous_preference
export interaction_names
export Layer
export LinearResponse
export ModelParameters
export mpnmodel
export multiplex_network_parameters_names
export MultiplexNetwork
export n_links
export nestedhierarchymodel
export nichemodel
export nontrophic_adjacency_matrix
export NonTrophicIntensity
export population_stability
export potential_competition_links
export potential_facilitation_links
export potential_interference_links
export potential_refuge_links
export producer_growth
export producers
export richness
export simulate
export species_persistence
export species_richness
export total_biomass
export trophic_levels

end
