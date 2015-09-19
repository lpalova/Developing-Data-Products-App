library(shiny)
library(ggplot2)
require(rCharts)

cars <- mtcars
cars$names <- rownames(mtcars)
y <- "Your car is shown in the figure as a green square."
col <- "seagreen4"
sh <- 18
sz <- 9

shinyServer(
        function( input, output ){
                
                output$oanalysis <- renderText({input$analysis})
                
                v <- reactiveValues( mycar = NULL )
                
                observeEvent( input$submitButton, {
                       v$mycar <- data.frame(
                                        mpg = input$mympg, 
                                        cyl = input$mycyl,
                                        disp = NA,
                                        hp = input$myhp, 
                                        drat = NA,
                                        wt = input$mywt/1000, 
                                        qsec = NA,
                                        vs = NA,
                                        am = as.numeric(input$myam == "Manual"), 
                                        gear = NA,
                                        carb = NA,
                                        names = "my car"
                                   )
                })
                observeEvent( input$clearButton, {
                        v$mycar <- NULL
                })
                
                set <- reactive(cars[input$carnames,])
                setmc = reactive(rbind(set(),v$mycar))
                output$tablenames <- renderDataTable(setmc())
                
                coef1 <- reactive(summary(lm(mpg ~ wt, set()))$coef)
                coef2 <- reactive(summary(lm(mpg ~ wt + am + am*wt, set()))$coef)
                coef3 <- reactive(summary(lm(mpg ~ hp, set()))$coef)
                coef4 <- reactive(summary(lm(mpg ~ hp + am + am*hp, set()))$coef)
                                
                output$plot <- renderPlot({
                        if (input$analysis == "Boxplot1"){
                                g <- ggplot(set(), aes(am, mpg)) + geom_boxplot(aes(fill = factor(am))) +
                                        scale_fill_manual( values = c("blue2", "orange2")) 
                                g <- g + labs( x ="Automatic (0)/ Manual (1) transmission", y = "Miles/(US) gallon", 
                                               title = "")
                                if ( !is.null(v$mycar) ){
                                        input$submitButton
                                        isolate(
                                                g <- g + geom_point(data = v$mycar, aes(am, mpg), 
                                                                    size = sz, colour = col, shape = sh)
                                        )
                                }
                                g
                        }
                        else if (input$analysis == "Boxplot2"){
                                g <- ggplot(set(), aes(factor(cyl),mpg)) + geom_boxplot(aes(fill = factor(am))) +
                                        scale_fill_manual( values = c("blue2", "orange2")) 
                                g <- g + labs( x ="Number of cylinders", y = "Miles/(US) gallon", 
                                               title = "")
                                if ( !is.null(v$mycar) ){
                                        input$submitButton
                                        isolate(
                                                g <- g + geom_point(data = v$mycar, aes(factor(cyl), mpg), 
                                                                    size = sz, colour = col, shape = sh)
                                        )
                                }
                                g
                        }
                        else if (input$analysis == "Scatterplot1"){
                                g <- ggplot(set(), aes(wt, mpg))
                                g <- g + geom_point(aes(color=factor(am)), size = 4)   
                                g <- g + scale_colour_manual( values = c("blue", "orange")) 
                                g <- g + geom_smooth( method = "lm", colour = "black")  
                                g <- g + labs (x = "Weight ( x1000 lb)", y = "Miles/(US) gallon")
                                if ( !is.null(v$mycar) ){
                                        input$submitButton
                                        isolate(
                                                g <- g + geom_point(data = v$mycar, aes(wt, mpg), 
                                                                    size = sz, colour = col, shape = sh)
                                        )
                                }
                                g
                        }
                        else if (input$analysis == "Scatterplot2"){
                                g <- ggplot(set(), aes(wt, mpg)) 
                                g <- g + geom_hline(yintercept = mean(subset(set(),am==0)$mpg), colour = "blue", linetype = 2)
                                g <- g + geom_hline(yintercept = mean(subset(set(),am==1)$mpg), colour = "orange", linetype = 2 )
                                g <- g + geom_point(aes(color=factor(am)), size = 4)   
                                g <- g + scale_colour_manual( values = c("blue", "orange")) 
                                g <- g + geom_abline(intercept = coef2()[1], slope = coef2()[2], colour = "blue" )
                                g <- g + geom_abline(intercept = coef2()[1]+coef2()[3], slope = coef2()[2]+coef2()[4], 
                                                     colour = "orange" )
                                g <- g + labs (x = "Weight ( x1000 lb)", y = "Miles/(US) gallon")
                                if ( !is.null(v$mycar) ){
                                        input$submitButton
                                        isolate(
                                                g <- g + geom_point(data = v$mycar, aes(wt, mpg), 
                                                                    size = sz, colour = col, shape = sh)
                                        )
                                }
                                g
                        }      
                        else if (input$analysis == "Scatterplot3"){
                                g <- ggplot(set(), aes(hp, mpg))
                                g <- g + geom_point(aes(color=factor(am)), size = 4)   
                                g <- g + scale_colour_manual( values = c("blue", "orange")) 
                                g <- g + geom_smooth( method = "lm", colour = "black")  
                                g <- g + labs (x = "Gross horsepower", y = "Miles/(US) gallon")
                                if ( !is.null(v$mycar) ){
                                        input$submitButton
                                        isolate(
                                                g <- g + geom_point(data = v$mycar, aes(hp, mpg), 
                                                                    size = sz, colour = col, shape = sh)
                                        )
                                }
                                g 
                        }
                        else if (input$analysis == "Scatterplot4"){
                                g <- ggplot(set(), aes(hp, mpg)) 
                                g <- g + geom_hline(yintercept = mean(subset(set(),am==0)$mpg), colour = "blue", linetype = 2)
                                g <- g + geom_hline(yintercept = mean(subset(set(),am==1)$mpg), colour = "orange", linetype = 2 )
                                g <- g + geom_point(aes(color=factor(am)), size = 4)   
                                g <- g + scale_colour_manual( values = c("blue", "orange")) 
                                g <- g + geom_abline(intercept = coef4()[1], slope = coef4()[2], colour = "blue" )
                                g <- g + geom_abline(intercept = coef4()[1]+coef4()[3], slope = coef4()[2]+coef4()[4], 
                                                     colour = "orange" )
                                g <- g + labs (x = "Weight ( x1000 lb)", y = "Miles/(US) gallon")
                                if ( !is.null(v$mycar) ){
                                        input$submitButton
                                        isolate(
                                                g <- g + geom_point(data = v$mycar, aes(hp, mpg), 
                                                                    size = sz, colour = col, shape = sh)
                                        )
                                }
                                g
                        }   
                
                })
                output$textplot <- renderText({
                        if (input$analysis == "Boxplot1"){
                                t <- "Boxplot of mpg by the transmission type (automatic = blue, manual = orange)."
                        }
                        else if (input$analysis == "Boxplot2"){
                                t <- "Boxplot of mpg by the number of cylinders and the transmission type (automatic = blue, manual = orange)."
                        }
                        else if (input$analysis == "Scatterplot1"){
                                t <- "Scatterplot of mpg ~ wt shows linear regression (solid black) line and confidence interval
                                (shaded region). Two transmission types are: automatic (blue) and manual (orange)."
                        }
                        else if (input$analysis == "Scatterplot2"){
                                t <- "Linear regression of mpg on wt is shown by the two transmision groups.
                                Dotted lines represent automatic (blue) and manual (orange) mpg means, disregarding car weight."
                        }  
                        else if (input$analysis == "Scatterplot3"){
                                t <- "Scatterplot of mpg ~ hp shows linear regression (solid black) line and confidence interval
                                (shaded region). Two transmission types are: automatic (blue) and manual (orange)."
                        }
                        else if (input$analysis == "Scatterplot4"){
                                t <- "Linear regression of mpg on hp is shown by the two transmision groups.
                                Dotted lines represent automatic (blue) and manual (orange) mpg means, disregarding car horse power."
                        }
                        if ( is.null(v$mycar) ){ t }
                        else { paste( t, y) }
                        
                })
                output$textregline <- renderText({
                        if (input$analysis == "Boxplot1" | input$analysis == "Boxplot2"){ "" }
                        else if (input$analysis == "Scatterplot1") { 
                                t <- "The intercept and slope of the regression line are: " 
                                is <- paste( round(coef1()[1],2), round(coef1()[2],2), sep =" and " )
                                isr <- paste( is, "respectively.", sep=", ")
                                paste( t, isr )
                        }
                        else if (input$analysis == "Scatterplot2") { 
                                t <- "The intercepts and slopes of the two regression lines are: " 
                                intsl1 <- paste( round(coef2()[1],2), round(coef2()[2],2), sep =", " )
                                intsl2 <- paste( round(coef2()[1]+coef2()[3],2), round(coef2()[2]+coef2()[4],2), "respectively.", sep =", " )
                                paste( t, "automatic:", intsl1, "manual:", intsl2 )
                        }
                        else if (input$analysis == "Scatterplot3") { 
                                t <- "The intercept and slope of the regression line are: " 
                                is <- paste( round(coef3()[1],2), round(coef3()[2],2), sep =" and " )
                                isr <- paste( is, "respectively.", sep=", ")
                                paste( t, isr )
                        }
                        else if (input$analysis == "Scatterplot4") { 
                                t <- "The intercepts and slopes of the two regression lines are: " 
                                intsl1 <- paste( round(coef4()[1],2), round(coef4()[2],2), sep =", " )
                                intsl2 <- paste( round(coef4()[1]+coef4()[3],2), round(coef4()[2]+coef4()[4],2), "respectively.", sep =", " )
                                paste( t, "automatic:", intsl1, "manual:", intsl2 )
                        }
                })
        }
)

