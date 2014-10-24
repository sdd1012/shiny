library(shiny)
shinyUI(pageWithSidebar(
        headerPanel("Estimate Miles per US gallon"),
        sidebarPanel(h4('Enter Your input here'),
                
                numericInput("inputWt", "Weight in pounds:", value=3000, min=1500,
                             max=5500),
                
                radioButtons("inputCyl", "Choose number cylinders:",
                             list("4-Cylinder" = "four",
                                  "6-Cylinder" = "six",
                                  "8-Cylinder" = "eight")),
                checkboxInput("inputUseHp", "Estimate with Horsepower", FALSE),
                conditionalPanel(condition = "input.inputUseHp == true",
                        sliderInput("inputHp", 
                           "Gross horsepower:", 
                            min = 50,
                            max = 350, 
                            value = 150, step = 10)),
                actionButton("goButton", "Start estimating>>")
        ),
        mainPanel(
                strong(textOutput('text1')),
                plotOutput(outputId = "main_plot", height = "440px"),
                p('The above modeled lines use weight as predictor, colored by cylinder type. The model for estimate uses your input.'),
                HTML('<a href="https://github.com/sdd1012/shiny">Click here for the code in github</a>')
                
        )
))