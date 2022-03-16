module LandingPageController

using Stipple
using StippleUI

@reactive! mutable struct ScenarioName <: ReactiveModel
  name::R{String} = ""
end

function landingUI(pModel)
    page(pModel, class="container", title="DT Viewer", [
        h2("Willkommen!")
        row(
            [
              cell([
                  btn("Less! ", @click("value -= 1"))
                ])
              cell([ 
                p([
                  "Erstelle neues Szenario:  "
                  input("", placeholder="Szenarioname", @bind(:name))
                ])
                btn("Hier passiert was", @click("window.open('https://errorsea.com','_self');"))
              ])
            ]
        )
    ])
end

function landing_view()
    model = init(ScenarioName)
    on(model.isready) do _
        push!(model)
    end

    html(landingUI(model), context = @__MODULE__)
end

end # end module