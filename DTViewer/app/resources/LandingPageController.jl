module LandingPageController

using Stipple
using StippleUI

@reactive! mutable struct FormModel <: ReactiveModel
          name::R{String} = ""
          age::R{Int} = 0
          warin::R{Bool} = true
end

function landingUI(pModel)
    page(pModel, class="container", title="DT Viewer", [
        h2("Willkommen!")
        StippleUI.form(action = "/sub", method = "POST", [
          textfield("What's your name *", :name, name = "name", @iif(:warin), :filled, hint = "Name and surname", "lazy-rules",
            rules = "[val => val && val.length > 0 || 'Please type something']"
          ),
          numberfield("Your age *", :age, name = "age", "filled", :lazy__rules,
            rules = "[val => val !== null && val !== '' || 'Please type your age',
              val => val > 0 && val < 100 || 'Please type a real age']"
          ),
          btn("submit", type = "submit", color = "primary")
       ])
    ])
end

function landing_view()
    model = init(FormModel)
    # on(model.isready) do _
    #     push!(model)
    # end

    html(landingUI(model), context = @__MODULE__)
end

end # end module