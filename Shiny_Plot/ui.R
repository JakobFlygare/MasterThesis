library(shiny)
#Define UI for application
shinyUI(fluidPage(
#Header or title Panel
    titlePanel(title =h4("Demonstration of rendearPlot() - a histogram", align="center")),
    sidebarLayout( 
#Sidebar panel
      sidebarPanel(
        selectInput("var","1. Select the variable from the iris dataset",
                    #here the values 1,2,3,4 represent the columns in the dataset
                    choices = c("Sepal.Length" = 1,"Sepal.Width" = 2, "Petal.Length" = 3,
                                "Petal.Width" = 4), selected = 1),
        br(),
        sliderInput("bins","2. Select the number of BINs for histogram",min=5,max=25,value=15),
        br(),
        radioButtons("color","3. Select the color of histogram", choices=c("Green","Red","Yellow"),
                     selected = "Green")
      ),
                     

                             
      mainPanel(
        plotOutput("myhist")
                )
    )
  )
)
