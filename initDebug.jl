using Genie, Stipple, StippleUI

@reactive mutable struct Test <: ReactiveModel
    changed::R{Bool} = false
end

function changeModel(pModel)
    pModel.changed[] = true
    return pModel
end

function initFirst()
    model = Stipple.init(Test())
    return changeModel(model)
end

function initLast()
    model = changeModel(Test())
    return Stipple.init(model)
end


a = initFirst()
b = initLast()

println(a.changed[])
println(b.changed[])

function ui(model)
    page(model, class = "container", [
        p(
            span("", @text(:changed))
        )
    ]) |> html
end

route("/a") do 
    ui(a)
end
route("/b") do 
    ui(b) 
end 

up(8020, open_browser=true)