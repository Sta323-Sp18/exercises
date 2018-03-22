library(shiny)
library(ggplot2)
library(dplyr)


colors = c("green", "red", "blue")


shinyApp(
  ui = fluidPage(
    titlePanel("Shiny Example - Beta-Binomial"),
    sidebarLayout(
      sidebarPanel(
        numericInput("sims", "Number of simulations:", value=1e6),
        actionButton("do_abc", "Run ABC simulation"),
        h4("Data:"),
        sliderInput("x", "Number of heads:", min=0, max=10, value=8),
        sliderInput("n", "Number of flips:", min=0, max=50, value=10),
        h4("Prior:"),
        numericInput("a", "Prior number of successes:", min=0, value=1),
        numericInput("b", "Prior number of failures:",  min=0, value=1),
        h4("Options:"),
        checkboxInput("facet", label = "Facet distributions", value = TRUE)
      ),
      mainPanel(
        plotOutput("dist"),
        plotOutput("abc")
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
      
      g = ggplot(d, aes(x=p, y=density, color=distribution)) +
        geom_line() +
        geom_area(aes(ymax = density, fill=distribution), alpha=0.2) +
        scale_color_manual(values = colors) +
        scale_fill_manual(values = colors)
      
      if (input$facet)
        g = g + facet_wrap(~distribution)

      g  
    })
    
    ## Step 1 - Sample prior
    p = eventReactive(
      input$do_abc,
      {
        cat("Sims:",input$sims,"\n")
        req(input$sims)
        validate(
          need(input$sims > 10000, "Number of simulations is too small, sims should be greater than 10,000"),
          need(input$sims <= 5e7, "Number of simulations is too large, sims should be less than 50,000,000")
        )
        
        rbeta(input$sims, input$a, input$b)
      }
    )
    
    ## Step 2 - Simulate data
    x_sim = eventReactive(
      p(),
      {
        rbinom(length(p()), size = input$n, prob = p())
      }
    )
    
    ## Step 3 - subset p
    post = eventReactive(
      x_sim(),
      {
        p()[input$x == x_sim()]
      }
    )
    
    
    output$abc = renderPlot({
      
      d = data_frame(post = post())
      
      print(length(post))
      
      ggplot(d, aes(x=post)) + 
        geom_density(fill="blue", alpha=0.2) + 
        xlim(0,1)
    }) 
  }
)