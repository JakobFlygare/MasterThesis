library(shiny)
library(chorddiag)
#Define UI for application
shinyUI(fluidPage(
  #Header or title Panel
  titlePanel(title =h4("Movement between sensors", align="center")),
  sidebarLayout( 
    #Sidebar panel
    sidebarPanel(
      checkboxGroupInput("sensorschord","Sensors to show",choices = c("200"="200","300"="300"),selected=c("200","300")),
      
      dateRangeInput("inputId", "labe", start = NULL, end = NULL, min = "2018-01-18",
                     max = "2018-02-03", format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                     language = "en", separator = " to ", width = NULL)
      
      ),
      #checkboxInput("confbars","Confidence interval",TRUE),
      #checkboxInput("stdsmooth","Standard deviation region",TRUE)),
    
    mainPanel(
      chorddiagOutput("chorddiag", height = 600)
    )
  )
)
)