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
        tabPanel("Operating System Distribution by Age Group", 
                 value = 1, 
                 plotOutput("os_by_age_group")),
        tabPanel("Average Screen On Time by Age", 
                 value = 2, 
                 plotOutput("screen_time_plot")),
        tabPanel("Correlation Analysis: App Usage Time vs Number of Apps", 
                 value = 3, 
                 plotOutput("correlation_plot")),
        tabPanel("Distribution of App Usage Time Across Age Groups", 
                 value = 4, 
                 plotOutput("app_usage_boxplot")),
        tabPanel("Screen On Time by Operating System", 
                 value = 5, 
                 plotOutput("screen_time_os")),
        tabPanel("App Usage Analysis: Frequency and Number of Apps Installed", 
                 value = 6, 
                 plotOutput("app_usage_hist"), 
                 plotOutput("app_usage_scatter"))
      )
    )
  )
)
