using Agenie
using Documenter

makedocs(;
    modules=[Agenie],
    authors="Amin Yahyaabadi",
    repo="https://github.com/aminya/Agenie.jl/blob/{commit}{path}#L{line}",
    sitename="Agenie.jl",
    format=Documenter.HTML(;
        canonical="https://aminya.github.io/Agenie.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/aminya/Agenie.jl",
)
