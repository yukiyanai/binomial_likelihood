#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

pacman::p_load(shiny,
               tidyverse,
               patchwork)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("二項分布の尤度関数と対数尤度関数"),
    br(),
    br(),
    
    sidebarLayout(
        sidebarPanel(
            img(src = "Yanai_lab_sticker.png", height = 120),
            br(),
            br(),
            numericInput("n",
                         withMathJax("$$\\text{試行回数}\\quad n \\leq 1000$$"),
                         min   = 1,
                         max   = 1000,
                         value = 10),
            numericInput("x",
                         withMathJax("$$\\text{成功回数}\\quad x \\quad (x \\leq n)$$"),
                         min   = 0,
                         max   = 1000,
                         value = 5),
            actionButton("update", "更新"),
            br(),
            br(),
            h4("最尤推定値"),
            textOutput("MLE")
            
            
        ),
        mainPanel(
            helpText(withMathJax("$$X \\sim \\mbox{Binomial}(n, \\theta)$$")),
            helpText(withMathJax("$$L(\\theta; n, x) = f(x; n, \\theta) = \\binom{n}{x}\\theta^x (1 - \\theta)^{n - x}$$")),
            helpText(withMathJax("$$\\ell(\\theta; n, x) = \\log \\binom{n}{x} +  x \\log \\theta + (n - x) \\log (1 - \\theta)$$")),
            plotOutput("llPlot")
            #plotOutput("distPlot")
        )
    )
))
