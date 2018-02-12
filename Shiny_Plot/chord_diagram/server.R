#setwd("/Users/jakob/Documents/R/MasterThesis/Shiny_Plot/chord_diagram")
library(shiny)
library(tidyverse)
## RUN OTHER SCRIPT BEFORE TO GENERATE DATA ##
#source("Visualization/chord_diagram.R")
shinyServer(
  function(input, output){
    
    output$chorddiag <-renderChorddiag({
      sensors <- input$sensorschord
      view_sensors <- cross_person %>%
        filter(Sensor_Code %in% sensors & prev_sensor %in% sensors)
      chordMat = matrix(as.numeric(unlist(view_sensors[3])),nrow=length(sensors))
      dimnames(chordMat) = list(sensors,sensors)
      
      #groupColors <- c("#000000", "#FFDD89", "#957244", "#F26223")
      chorddiag(chordMat, groupnamePadding = 50, margin= 90)
    })    
    
  }
  
)
