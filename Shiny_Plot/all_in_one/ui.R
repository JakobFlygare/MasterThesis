shinyUI(navbarPage(
  theme = shinytheme("cerulean"),  # <--- To use a theme, uncomment this
  "GrowSmarter",
  tabPanel("Chord diagram",
           titlePanel(title =h4("Movement between sensors", align="center")),
           sidebarLayout( 
             #Sidebar panel
             sidebarPanel(
               checkboxGroupInput("sensorschord","Sensors to show",choices = c("200"="200","300"="300"),selected=c("200","300"))),
             #checkboxInput("confbars","Confidence interval",TRUE),
             #checkboxInput("stdsmooth","Standard deviation region",TRUE)),
             
             mainPanel(
               chorddiagOutput("chorddiag", height = 600)))),
  tabPanel("Daily ping patterns", 
           titlePanel(title =h4("Hourly pings", align="center")),
           sidebarLayout( 
             #Sidebar panel
             sidebarPanel(
               checkboxGroupInput("sensor","Sensors to show",choices = c("200"="200","300"="300"),selected="300"),
               br("View settings"),
               checkboxInput("confbars","Confidence interval",TRUE),
               checkboxInput("stdsmooth","Standard deviation region",TRUE)),
             
             mainPanel(
               plotOutput("hourlyping")
             )
           )),
  tabPanel("Navbar 3", "This panel is intentionally left blank")
)
)