module JsonHelper
using JSON
export parseMeasureJSON

function parseMeasureJSON(pPath::String)
    measures = []
    categories = []
    measureID = 1
    catID = 1
    open(pPath, "r") do file
      inputJSON = JSON.parse(file)
      for entry in inputJSON
        category = Category(catID, entry["category"], entry["maxChoices"])
        push!(categories, category)
        for option in entry["items"]
          optionTitle = option["title"]
          optionDescription = option["shortDescription"]
          push!(measures, Measure(measureID, optionTitle, optionDescription, category))
          measureID += 1
          catID += 1
        end
      end
    end
    return measures, categories
end

end # end of module