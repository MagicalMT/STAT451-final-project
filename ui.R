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
  titlePanel("User Behavior Analysis Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "input.tabselected == 1",
        selectInput(
          inputId = "age_group",
          label = "Select Age Group for Operating System Distribution:",
          choices = c("None"),
          selected = "None"
        )
      ),
      conditionalPanel(
        condition = "input.tabselected == 2",
        selectInput(
          inputId = "gender_q2",
          label = "Select Gender for Average Screen On Time:",
          choices = c("None", "Both (Combined)", "Male", "Female"),
          selected = "None"
        )
      ),
      conditionalPanel(
        condition = "input.tabselected == 3",
        selectInput(
          inputId = "vars_q3",
          label = "Select Variables for Correlation Analysis:",
          choices = c("None"),
          multiple = TRUE
        )
      ),
      conditionalPanel(
        condition = "input.tabselected == 4",
        selectInput(
          inputId = "age_groups_q4",
          label = "Add Age Groups for App Usage Time Distribution:",
          choices = c("None"),
          multiple = TRUE,
          selected = "None"
        )
      ),
      conditionalPanel(
        condition = "input.tabselected == 5",
        selectInput(
          inputId = "os_q5",
          label = "Select Operating System for Screen On Time Analysis:",
          choices = c("None"),
          selected = "None"
        )
      ),
      conditionalPanel(
        condition = "input.tabselected == 6",
        selectInput(
          inputId = "os_q6",
          label = "Select Operating System for App Usage Analysis:",
          choices = c("None"),
          selected = "None"
        )
      )
    ),
    mainPanel(
      tabsetPanel(
        id = "tabselected",
        tabPanel("Question 1: What is the distribution of operating systems by age group?", 
                 value = 1, 
                 plotOutput("os_by_age_group"),
                 textOutput("os_analysis")),
        tabPanel("Question 2: How does average screen on time vary by age?", 
                 value = 2, 
                 plotOutput("screen_time_plot"),
                 textOutput("screen_time_analysis")),
        tabPanel("Question 3: Is there a correlation between app usage time and the number of apps installed?", 
                 value = 3, 
                 plotOutput("correlation_plot"),
                 textOutput("correlation_analysis")),
        tabPanel("Question 4: How is app usage time distributed across different age groups?", 
                 value = 4, 
                 plotOutput("app_usage_boxplot")),
        tabPanel("Question 5: How does screen on time differ by operating system?", 
                 value = 5, 
                 plotOutput("screen_time_os")),
        tabPanel("Question 6: What is the relationship between app usage time and the number of apps installed?", 
                 value = 6, 
                 plotOutput("app_usage_hist"), 
                 plotOutput("app_usage_scatter"))
        
      )
    )
  )
)
