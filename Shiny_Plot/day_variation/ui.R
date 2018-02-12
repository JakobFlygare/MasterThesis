library(shiny)
#Define UI for application
shinyUI(fluidPage(
  #Header or title Panel
  titlePanel(title =h4("Histogram of unique pings per sensor, w/ confidence interval and sd. region", align="center")),
  sidebarLayout( 
    #Sidebar panel
    sidebarPanel(
      checkboxGroupInput("sensor","Sensors to show",choices = c("200"="200","300"="300"),selected="300"),
      br("View settings"),
      checkboxInput("confbars","Confidence interval",TRUE),
      checkboxInput("stdsmooth","Standard deviation region",TRUE)),
    
    mainPanel(
      plotOutput("myplot")
    )
  )
)
)