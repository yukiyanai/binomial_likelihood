#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

pacman::p_load(shiny,
               tidyverse,
               patchwork)

if (.Platform$OS.type == "windows") {
    # Windows
    if (require(fontregisterer)) my_font <- "Yu Gothic"
    else my_font <- "Japan1"
} else if (capabilities("aqua")) {
    # macOS
    my_font <- "HiraginoSans-W3"
} else {
    # Unix/Linux
    my_font <- "IPAexGothic"
}
theme_set(theme_gray(base_size   = 9,
                     base_family = my_font))

# Likelihood function
f_L <- function(theta, n , x) {
    choose(n, x) * theta^x * (1 - theta) ^(n - x)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    n <- eventReactive(input$update, {
        input$n
    })
    
    x <- eventReactive(input$update, {
        input$x
    })
        
    output$llPlot <- renderPlot({
        n <- n()
        x <- x()
        myd <- tibble(theta = seq(from = 0, to = 1, length.out = 1e4)) %>% 
            mutate(L  = sapply(theta, f_L, n = n, x = x)) %>% 
            mutate(LL = log(L))
        base <- ggplot(myd, aes(x = theta)) +
            geom_vline(xintercept = x / n, 
                       color = "tomato", 
                       linetype = "dashed") +
            scale_x_continuous(breaks = seq(from = 0, to = 1, by = 0.2))
        plt_L <- base +
            geom_path(aes(y = L), color = "darkblue") +
            labs(x = expression(theta), y = "尤度")
        plt_LL <-  base + 
            geom_path(aes(y = LL), color = "darkgreen") +
            labs(x = expression(theta), y = "対数尤度")
        plot(plt_L / plt_LL)
    })
    
    output$MLE <- renderText({
        as.character(x() / n())
    })
})
