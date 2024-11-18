#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

ui <- fluidPage(
  titlePanel("Project Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "input.tabselected == 1",
        selectInput("age_group", "Select Age Group:", choices = NULL)
      ),
      conditionalPanel(
        condition = "input.tabselected == 2",
        selectInput("gender_q2", "Select Gender or Combined Data:",
                    choices = c("Both (Combined)", "Male", "Female"))
      ),
      conditionalPanel(
        condition = "input.tabselected == 3",
        selectInput(
          inputId = "vars_q3",
          label = "Select Variables for Correlation Analysis:",
          choices = NULL,
          multiple = TRUE
        )
      ),
      conditionalPanel(
        condition = "input.tabselected == 4",
        selectInput("age_groups_q4", "Add Age Groups:", choices = NULL, multiple = TRUE)
      ),
      conditionalPanel(
        condition = "input.tabselected == 5",
        selectInput("os_q5", "Select Operating System:", choices = NULL)
      ),
      conditionalPanel(
        condition = "input.tabselected == 6",
        selectInput("os_q6", "Select Operating System:", choices = NULL)
      )
    ),
    
    mainPanel(
      tabsetPanel(
        id = "tabselected",
        tabPanel("Question 1", value = 1, plotOutput("os_by_age_group")),
        tabPanel("Question 2", value = 2, plotOutput("screen_time_plot")),
        tabPanel("Question 3", value = 3, plotOutput("correlation_plot")),
        tabPanel("Question 4", value = 4, plotOutput("app_usage_boxplot")),
        tabPanel("Question 5", value = 5, plotOutput("screen_time_os")),
        tabPanel("Question 6", value = 6, 
                 plotOutput("app_usage_hist"), 
                 plotOutput("app_usage_scatter"))
      )
    )
  )
)
