# used to isolate model problem: https://github.com/GenieFramework/Stipple.jl/issues/97
using Stipple, StippleUI

@reactive mutable struct Test <: ReactiveModel
    changed::R{Bool} = false
    sweetVec::R{Vector} = []
end

function changeModel!(pModel)
    pModel.changed[] = true
    pModel.sweetVec[] = ["abc","def"]

    pModel
end

function initHandlers(pModel)
    on(pModel.isready) do isready
        isready || return
        @async begin
            sleep(0.1)
            push!(pModel)
        end
    end

    return pModel
end

c = init(Test, debounce = 0) |> initHandlers |> changeModel!

println(c.changed[])

function ui(model::Test)

    page(model, class = "container", [
        p(
            span("", @text(:changed))
        )
        p(" {{vec}} ", @recur(:"vec in sweetVec"))
    ]) |> html
end

route("/") do 
    println(c.changed[])
    ui(c) 
end 
up(8020, open_browser=true)