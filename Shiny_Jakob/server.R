library(shiny)
shinyServer(
  function(input, output){

output$myhist <- renderPlot({
  #var is connected to var from ui.R, and need numeric since it's a string
  #bins connected to number of bins the user wants
  colm <- as.numeric(input$var)
  hist(iris[,colm], breaks=seq(0,max(iris[,colm]),l=input$bins+1),col=input$color,main = "Histogram of iris dataset",xlab=names(iris[colm]))
})    
    
  }
  
  )