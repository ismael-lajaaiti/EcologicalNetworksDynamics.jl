function generate_dbdt_compact(parms::ModelParameters)

    # TODO: producers competition and non-trophic layers
    # are onlaying new structures on the overall SxS matrix.
    # The entire point of the code generated in this function
    # is to avoid that every timestep becomes like:
    #
    #     for (i, j) in SxS
    #        if is_trophic(i, j)
    #           do-trophism
    #        if is_competition(i, j)
    #           do-competition
    #        if is_whatever_non_trophic_layer(i, j)
    #           do-that-layer
    #        etc.
    #     end
    #
    # .. because
    # 1) SxS can be large
    # 2) All branches can be predicted at compile-time
    #    because the MultiplexNetwork structure
    #    does not evolve during calls to `solve()`.
    #
    # However, the current implementation does not integrate
    # this multi-level interactions organization yet,
    # but it should to prepare facing future evolution of the package.
    # Do this refactorization now
    # before integrating MultiplexNetwork and producers competition.
    #
    # This will probably necessitate that all "sections"
    # of the generated code (living now in `productivity.jl`, `consumption.jl` etc.)
    # be reunited here and be treated as one single, optimized block.

    # Prepare collection of pre-calculated data.
    data = Dict()

    code = :(function (dB, B, p, t)

        (data, extinct_species) = p
        # TODO: this extra loop should be avoided
        # within the new `:compact` framework, taking all links layers into account.
        for i in keys(extinct_species)
            B[i] = 0
        end

        # Lines are generated here.

    end)

    # Gather all generated code and data.
    chunks_generators = [
        parms.functional_response,
        # Calculate consumption terms first
        # because they constitute a full pass over all dB[i] values
        # and it's an opportunity to initialize them.
        consumption,
        # Then the other terms, which may be done in partial passes.
        growth,
        metabolism_loss,
    ]
    chunks = []
    data = Dict()
    for gen in chunks_generators
        # Correctly dispatch with dummy :_ symbol arguments.
        # Alternative: move FunctionalResponse functor definitions
        # in a dedicated file *after* 'ModelParameters' has been declared
        # so it may appear in their signature.
        c, d = gen(parms, :_)
        append!(chunks, c)
        for (k, v) in d
            if haskey(data, k) && v != data[k]
                throw(
                    AssertionError(
                        "Error in package source: \n" *
                        "$(gen) code generator produced data '$(k)': $v " *
                        "($(typeof(v)))\n" *
                        "inconsistently with previously generated data '$(k)': $(data[k]) " *
                        "($(typeof(data[k])))\n",
                    ),
                )
            end
            data[k] = v
        end
    end

    # Construct/compile one large named tuple from the data.
    # Also, one large destructuring assignment line
    # to have all members available as plain variables
    # for the rest of the generated code.
    structuring = Expr(:tuple)
    destructuring = :(() = data)
    for (k, v) in data
        push!(structuring.args, Expr(:(=), k, v))
        push!(destructuring.args[1].args, k)
    end
    data = eval(structuring)

    # Insert all these lines and chunks into the generated function.
    push_line!(line) = push!(code.args[2].args, line)
    push_line!(destructuring)
    for l in chunks
        push_line!(l)
    end

    return code, data
end
