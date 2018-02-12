#setwd("/Users/jakob/Documents/R/MasterThesis/Shiny_Plot/day_variation")
library(shiny)
library(tidyverse)
## RUN OTHER SCRIPT BEFORE TO GENERATE DATA ##
#source("Visualization/plot_trend_lines.R")
shinyServer(
  function(input, output){
    
    output$myplot <- renderPlot({
      #var is connected to var from ui.R, and need numeric since it's a string
      #bins connected to number of bins the user wants
      sensorctrl <- input$sensor
      confctrl <- input$confbars
      stdctrl <- input$stdsmooth
      
      ggplot(subset(mean_sd_num_hr,Sensor_Code %in% c(sensorctrl)), aes(x=h, y=mean_num, colour=factor(Sensor_Code),group=Sensor_Code)) + 
        geom_errorbar(aes(ymin=mean_num-ci, ymax=mean_num+ci), width=0.5,alpha=1*(confctrl)) +
        geom_smooth(alpha=0.5*(stdctrl)) +
        #geom_line() +
        geom_point() +
        xlab("Hour") +
        ylab("Average Number of Unique Devices")+
        scale_colour_discrete(name  ="Sensor Code")
    })    
    
  }
  
)
