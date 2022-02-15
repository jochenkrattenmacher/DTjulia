# simpleSim

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

### Scenario module
This module provides an interactive frontend to select predefined measures. The measures and their consequences have to comply to a yet to be defined schema.

### Data visualisation module
This module will display the results and the consequences of the scenario(s). This includes different plots and possibly maps(?).
 
## Tools

### reveal.js
[Reveal.js documentation](https://revealjs.com/)

### genie.jl
[Genie documentation](https://www.genieframework.com/)

### stipple.jl
[Stipple repo](https://github.com/GenieFramework/Stipple.jl)