library(shiny)

shinyUI(fluidPage(
        titlePanel("Exploring Mtcars Dataset"),
        fluidRow(
                column( width = 12, 
                "This application focuses on running an exploratory data analysis
                on the mtcars dataset.
                 Using this app, you can plot 6 different exploratory graphs (called analysis) 
                of miles per gallon (mpg)
                as a function of gross horsepower (hp), weight (wt), transmission type (am)
                or number of cylinders (cyl).
                You can observe changes in these dependences based on the change in the dataset
                by including/exluding data points (car make/model observations).
                In addition, you can add characteristics of your own model to see how good it performs
                with respect to the dataset. This additional observation (called 'my car') is displayed in the graphs
                as a green diamond and can be added or erased from the graphs by hitting the 
                Submit or Clear button, respectively.
                Notice that 'my car' datapoint does not change the analysis (e.g. regression line) performed on the 
                rest of the dataset.
                The input parameters are displayed in the left panel, whereas results are 
                displayed in the right panel of the app.
                In addition to a graph corresponding to a particular type of analysis,
                you have the option to explore the underlying working dataset 
                in the table below the graph; 'my car' data point is included for comparison.
                The table is updated as you add or erase observations.
                Feel free to sort the datapoints by miles per gallon or any other variable.
                "
                )
        ),
        sidebarLayout(
                sidebarPanel(
                        p('Use checkboxes to include or exlude data points.'),
                        checkboxGroupInput("carnames",
                                           "Car Make and Model",
                                           rownames(mtcars),
                                           selected = rownames(mtcars)
                        ),
                        selectInput("analysis",
                                    "Analysis",
                                    c("Boxplot1: mpg ~ am" = "Boxplot1",
                                      "Boxplot2: mpg ~ cyl + am" = "Boxplot2",
                                      "Scatterplot1: mpg ~ wt, linear fit" = "Scatterplot1",
                                      "Scatterplot2: mpg ~ wt + am, linear fit by am" = "Scatterplot2",
                                      "Scatterplot3: mpg ~ hp, linear fit" = "Scatterplot3",
                                      "Scatterplot4: mpg ~ hp + am, linear fit by am" = "Scatterplot4"
                                     ),
                                     selected = "Boxplot1"
                        ),
                        h3('Show my car'),
                        numericInput('mympg',
                                     'Miles/(US) gallon',
                                      20, min=10, max=40, step=0.1
                        ),
                        selectInput("myam",
                                    "Transmission",
                                    c("Automatic",
                                      "Manual"
                                     ),
                                    selected = "Automatic"
                        ),
                        numericInput("mycyl",
                                     "Number of cylinders",
                                       6, min=4, max=8, step=2
                        ),
                        numericInput("myhp",
                                     "Gross horsepower",
                                      123, min=50, max=340, step=0.5
                        ),
                        numericInput("mywt",
                                     "Weight (lb)",
                                     3325, min=1500, max=5500, step=5
                        ),
                        actionButton("submitButton", "Submit"),
                        actionButton("clearButton", "Clear")
                ),
                
                mainPanel(
                        h3('Analysis:'),
                        verbatimTextOutput("oanalysis"),
                        plotOutput("plot", height = "500px"),
                        textOutput("textplot"),
                        textOutput("textregline"),
                        h4('Analysis Performed on:'),
                        dataTableOutput("tablenames")
                )
        )
))


