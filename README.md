# simpleSim
Webapplication for the presentation and interaction with models in Decision Theatres

# current problems
display active tab with measures
- the html already contains the correct content
    - the reactive model does not work yet as intended, on the first load the content is transferred , there is an open git issue and the developers are on it
    - Next steps: set first tab active -> button change active tab (in-/decrease the tab counter)

## Usage
The genie webservice can be started with the script for the desired OS under DTViewer/bin/server<.bat>. The service can only ended by exiting the process (crtl + c).
Test scripts like the initDebug can be just started  with julia and they will run asyncronous in the shell. This means, that they post their output to the terminal but new commands, e.g. down() can be issued.

## Components

The application consists of three main components. 

1. presentation module based on reveal.js
2. interactive scenario module, based on stipple.jl and stippleUI.jl
3. data visualisation module, also based on stipple.jsand stippleCharts.jl

The three modules are served by a genie webserver and are designed for local use only.

### Presentation module
This module will be used to display introduction presentations. The presentations have to be created in html in the backend, but a template presentation will be provided.

#### TODO
- create template
    - add banner for eventname, logos ...
    - show basic functionality
        - text
        - images
        - animated gifs
        - highlighting


### Scenario module
This module provides an interactive frontend to select predefined measures. The measures and their consequences have to comply to a yet to be defined schema.
The module takes the measures and other input classes as a json file and processes it to an array of measures and categories. The categories are parents objects in the json file. The reactive model stores all categories, measures, the selected measures and the active category. 

Note: The multi user functionality with several sessions is only implemented and not yet tested or verified! In theory, the group name is set as the session id and the model for the differnet sessions are stored in an array. This allows the attribution of models to the group scenarios.
#### TODO
- dynamic web interface
    - restrict options
    - store and process selection
    - multi user functionality


### Data visualisation module
This module will display the results and the consequences of the scenario(s). This includes different plots and possibly maps(?).
 
#### TODO
- basic plots
    - selected measures as input
    - link measures and consequences
        - motmo name convention: CH0SP0SE1WE0BP1RE0CO0DI0WO1CS0
            - acronyms + bool
    - make results compareable
- store results


## Tools

### reveal.js
[Reveal.js documentation](https://revealjs.com/)


### genie.jl
[Genie documentation](https://www.genieframework.com/)
Genie is a web framework for Julia. 
In routes.jl the valid URIs are specified with the behaviour. The page controllers, that build the web content, are located under app/recources/<resourceName>/. In these folders there also can be views, that contain template html code.
The input data should be placed under app/data/ and can be exchanged.

### stipple.jl
[Stipple repo](https://github.com/GenieFramework/Stipple.jl)
Stipple is a reactive webframe work written in Julia. It translates julia commands into js and vue.js. At the core of the framework is a reactive model, that is used for the communication between the front end side and back end side. The model is initialised like a struct and can be used as such in the back end. 
During the startup of the application, the js version of the model gets pushed to the front end and has to be connected to an instance in the backend. (At the moment, the developers try to abstract this behaviour, I opened up a git issue, which should contain the latest changes: https://github.com/GenieFramework/Stipple.jl/issues/97)
To display the values of the model in the front end, both stipple macros, like `@text(:choices)`, and inline js-code,like `@click("activeCategory += 1")` can be used. 

The design elements of stipple are interpreted with qasar and vue.js and thus accept vue parameters as well: 
Also there are macros for vue.js control structures like loops and conditions, that can be appended to elemets as paramter:
```
- @iif(:isready)
- @recur(:"entry in measures")
```