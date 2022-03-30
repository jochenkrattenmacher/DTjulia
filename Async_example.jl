# code from github issue: https://github.com/GenieFramework/Stipple.jl/issues/97
using Stipple, StippleUI

@reactive! mutable struct Test <: ReactiveModel
    changed::R{Bool} = false
    sweetVec::R{Vector} = []
end

function changeModel!(model)
    model.changed[] = true
    model.sweetVec[] = ["ab", "cd", "ef", "gh"]

    model
end

function handlers(model)
    on(model.isready) do isready
        isready || return
        changeModel!(model)
    end

    on(model.changed) do val
      @show val
      notify(model, "The model has changed")
    end

    model
end

function ui(model::Test)
    page(model, class = "container", row(cell(class = "st-module", [
        toggle("Changed", :changed)
        list("", :bordered, :separator, style = "max-width: 25vw",
            [item("Hello {{ sweetVec[$(i-1)] }} ", :clickable, :v__ripple) for i in 1:length(model.sweetVec[])]
        )
        separator()
        list("", :bordered, :separator, style = "max-width: 25vw",
            [item("World {{ vec }}", @recur("vec in sweetVec"), :clickable, :v__ripple)]
        )
    ])), @iif(:isready)) |> html
end

route("/") do 
    ui(init(Test, transport = Genie.WebChannels) |> handlers)
end

up(8020, open_browser = true)