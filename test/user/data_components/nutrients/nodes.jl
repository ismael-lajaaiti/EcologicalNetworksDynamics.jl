@testset "Nutrients nodes component." begin

    # At its core, a raw, autonomous compartment.
    n = Nutrients.Nodes(3)
    m = Model(n)
    @test m.n_nutrients == m.nutrients_richness == 3
    @test m.nutrients_names == [:n1, :n2, :n3]

    m = Model(Nutrients.Nodes([:a, :b, :c]))
    @test m.nutrients_index == OrderedDict(:a => 1, :b => 2, :c => 3)

    @sysfails(
        Model(Nutrients.Nodes([:a, :b, :a])),
        Check(Nutrients.RawNodes),
        "Nutrients 1 and 3 are both named :a."
    )

    # But blueprints exist to construct it from a foodweb.
    n = Nutrients.Nodes(:one_per_producer)
    m = Model(Foodweb([:a => :b, :c => :d])) + n
    @test m.n_nutrients == 2
    @test m.nutrients_names == [:n1, :n2]

    @sysfails(
        Model(n),
        Check(Nutrients.NodesFromFoodweb),
        "missing required component '$Foodweb'.",
    )

end
