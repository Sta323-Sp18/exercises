library(shiny)
library(ggplot2)
library(dplyr)


colors = c("green", "red", "blue")


shinyApp(
  ui = fluidPage(
    titlePanel("Shiny Example - Beta-Binomial"),
    sidebarLayout(
      sidebarPanel(
        h4("Data:"),
        sliderInput("x", "Number of heads:", min=0, max=10, value=8),
        sliderInput("n", "Number of flips:", min=0, max=50, value=10),
        h4("Prior:"),
        numericInput("a", "Prior number of successes:", min=0, value=1),
        numericInput("b", "Prior number of failures:",  min=0, value=1),
        h4("Options:"),
        checkboxInput("facet", label = "Facet distributions", value = TRUE),
        checkboxInput("plot_colors", label = "Customize plot colors", value = FALSE),
        conditionalPanel(
          "input.plot_colors == true",
          selectInput("prior", "Prior color", choices = colors, selected = colors[1]),
          selectInput("likelihood", "Likelihood color", choices = colors, selected = colors[2]),
          selectInput("posterior", "Posterior color", choices = colors, selected = colors[3])  
        )
        
      ),
      mainPanel(
        plotOutput("dist")
      )
    )
  ),
  server = function(input, output, session) {
    
    observeEvent(
      input$a,
      {
        if (is.na(input$a)) {
          updateNumericInput(session, "a", value=1)
          warning("Missing value for a")
        } else if (input$a < 0) {
          updateNumericInput(session, "a", value=1)
          warning("Bad value of a")
        }
      }
    )
    
    observeEvent(
      input$b,
      {
        if (is.na(input$b)) {
          updateNumericInput(session, "b", value=1)
        } else if (input$b < 0) {
          updateNumericInput(session, "b", value=1)
        }
      }
    )
    
    observeEvent(input$prior, {
      if (input$prior == input$likelihood)
        updateSelectInput(session, "likelihood", selected = setdiff(colors, c(input$prior, input$posterior)))
      if (input$prior == input$posterior)
        updateSelectInput(session, "posterior", selected = setdiff(colors, c(input$prior, input$likelihood)))
    })
    
    observeEvent(input$likelihood, {
      if (input$likelihood == input$prior)
        updateSelectInput(session, "prior", selected = setdiff(colors, c(input$prior, input$posterior)))
      if (input$likelihood == input$posterior)
        updateSelectInput(session, "posterior", selected = setdiff(colors, c(input$prior, input$likelihood)))
    })
    
    observeEvent(input$posterior, {
      if (input$posterior == input$likelihood)
        updateSelectInput(session, "likelihood", selected = setdiff(colors, c(input$prior, input$posterior)))
      if (input$posterior == input$prior)
        updateSelectInput(session, "prior", selected = setdiff(colors, c(input$prior, input$likelihood)))
    })
    
    observeEvent(
      input$n,
      updateSliderInput(session, "x", max = input$n)
    )
    
    output$dist = renderPlot({
      d = data_frame(
        p = seq(0, 1, length.out = 100)
      ) %>% mutate(
        prior = dbeta(p, input$a, input$b),
        likelihood = dbinom(input$x, size = input$n, prob = p),
        posterior = dbeta(p, input$a + input$x, input$b + input$n - input$x)
      ) %>% 
        tidyr::gather(distribution, density, -p) %>%
        mutate(distribution = forcats::as_factor(distribution))
      
      selected_colors = c(input$prior, input$likelihood, input$posterior)
      
      g = ggplot(d, aes(x=p, y=density, color=distribution, fill=distribution)) +
        geom_line() +
        geom_area(aes(ymax = density), alpha=0.5) +
        scale_color_manual(values = selected_colors) +
        scale_fill_manual(values = selected_colors)
      
      if (input$facet)
        g = g + facet_wrap(~distribution)

      g  
    })
  }
)