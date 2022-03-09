# simpleSim

# current problems
display active tab with measures
- the html already contains the correct content
- set first tab active -> change active tab

Webapplication for the presentation and interaction with models in Decision Theatres
## Usage


## Components

The application consists of three main components. 

1. presentation module based on reveal.js
2. interactive scenario module, based on stipple.jl
3. data visualisation module, also based on stipple.js

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

#### TODO
- dynamic web interface
    - measures as input
    - display measures and descriptions
    - make measures selectable
    - restrict options
    - store and process selection


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

### stipple.jl
[Stipple repo](https://github.com/GenieFramework/Stipple.jl)