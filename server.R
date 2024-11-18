#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(corrplot)
library(ggcorrplot)

server <- function(input, output, session) {
  data <- read.csv("../data/user_behavior_dataset.csv")
  
  data$Age_Group <- cut(
    data$Age,
    breaks = c(18, 28, 38, 48, 60, Inf),
    labels = c("18-28", "29-38", "39-48", "49-60", "60+"),
    right = FALSE
  )
  
  ## ----- Question 1 -----
  observe({
    age_groups <- unique(data$Age_Group)
    updateSelectInput(session, "age_group", choices = age_groups, selected = age_groups[1])
  })
  
  output$os_by_age_group <- renderPlot({
    req(input$age_group)
    filtered_data <- data %>%
      filter(Age_Group == input$age_group) %>%
      group_by(Operating.System) %>%
      summarise(Count = n(), .groups = "drop") %>%
      mutate(Percentage = Count / sum(Count) * 100)
    
    ggplot(filtered_data, aes(x = "", y = Percentage, fill = Operating.System)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y") +
      labs(title = paste("Operating System Distribution - Age Group:", input$age_group),
           fill = "Operating System") +
      theme_void() +
      geom_text(aes(label = paste0(round(Percentage, 1), "%")), 
                position = position_stack(vjust = 0.5))
  })
  
  ## ----- Question 2 -----
  output$screen_time_plot <- renderPlot({
    if (input$gender_q2 == "Both (Combined)") {
      screen_time_combined <- data %>%
        group_by(Age) %>%
        summarise(Average_Screen_On_Time = mean(Screen.On.Time..hours.day., na.rm = TRUE), .groups = "drop")
      
      ggplot() +
        geom_point(data = data, aes(x = Age, y = Screen.On.Time..hours.day., color = "Combined"), alpha = 0.4) +
        geom_smooth(data = screen_time_combined, aes(x = Age, y = Average_Screen_On_Time, color = "Combined"),
                    method = "loess", span = 0.3, se = FALSE) +
        scale_color_manual(values = c("Combined" = "black"), labels = c("Combined" = "Combined (Both Genders)")) +
        labs(
          title = "Average Screen On Time by Age (Combined for Both Genders)",
          x = "Age",
          y = "Average Screen On Time (hours/day)",
          color = "Legend"
        ) +
        theme_minimal()
    } else {
      screen_time_individual <- data %>%
        filter(Gender == input$gender_q2) %>%
        group_by(Age) %>%
        summarise(Average_Screen_On_Time = mean(Screen.On.Time..hours.day., na.rm = TRUE), .groups = "drop")
      
      gender_color <- ifelse(input$gender_q2 == "Male", "blue", "red")
      
      ggplot(screen_time_individual, aes(x = Age, y = Average_Screen_On_Time, color = input$gender_q2)) +
        geom_point(alpha = 0.6) +
        geom_smooth(method = "loess", span = 0.3, se = FALSE) +
        scale_color_manual(values = setNames(c(gender_color), input$gender_q2),
                           labels = setNames(input$gender_q2, input$gender_q2)) +
        labs(
          title = paste("Average Screen On Time by Age (Gender:", input$gender_q2, ")"),
          x = "Age",
          y = "Average Screen On Time (hours/day)",
          color = "Legend"
        ) +
        theme_minimal()
    }
  })
  
  ## ----- Question 3 -----
  observe({
    variable_choices <- colnames(data)[sapply(data, is.numeric)]
    updateSelectInput(session, "vars_q3", choices = variable_choices, selected = variable_choices[1:3])
  })
  
  output$correlation_plot <- renderPlot({
    req(length(input$vars_q3) >= 2)
    correlation_data <- data %>% select(all_of(input$vars_q3))
    correlation_matrix <- cor(correlation_data, use = "complete.obs")
    corrplot(
      correlation_matrix,
      method = "color",
      type = "upper",
      tl.srt = 45,
      title = "Correlation Matrix",
      addCoef.col = "red"
    )
  })
  
  ## ----- Question 4 -----
  observe({
    age_groups <- unique(data$Age_Group)
    updateSelectInput(session, "age_groups_q4", choices = age_groups, selected = age_groups)
  })
  
  output$app_usage_boxplot <- renderPlot({
    req(input$age_groups_q4)
    filtered_data <- data %>% filter(Age_Group %in% input$age_groups_q4)
    ggplot(filtered_data, aes(x = Age_Group, y = App.Usage.Time..min.day., fill = Age_Group)) +
      geom_boxplot(outlier.color = "red", outlier.shape = 1) +
      scale_fill_brewer(palette = "Set3") +
      labs(
        title = "Distribution of App Usage Time Across Selected Age Groups",
        x = "Age Group",
        y = "Daily App Usage Time (minutes)"
      ) +
      theme_minimal()
  })
  
  ## ----- Question 5 -----
  observe({
    os_choices <- c("All", unique(data$Operating.System))
    updateSelectInput(session, "os_q5", choices = os_choices, selected = "All")
  })
  
  output$screen_time_os <- renderPlot({
    filtered_data <- if (input$os_q5 != "All") {
      data %>% filter(Operating.System == input$os_q5)
    } else {
      data
    }
    
    ggplot(filtered_data, aes(x = Operating.System, y = Screen.On.Time..hours.day., fill = Operating.System)) +
      geom_boxplot(outlier.color = "red", outlier.shape = 1) +
      scale_fill_brewer(palette = "Set3") +
      labs(
        title = paste("Screen On Time by Operating System (Filtered:", input$os_q5, ")"),
        x = "Operating System",
        y = "Screen On Time (hours/day)"
      ) +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  ## ----- Question 6 -----
  observe({
    os_choices <- c("All", unique(data$Operating.System))
    updateSelectInput(session, "os_q6", choices = os_choices, selected = "All")
  })
  
  output$app_usage_hist <- renderPlot({
    filtered_data <- if (input$os_q6 != "All") {
      data %>% filter(Operating.System == input$os_q6)
    } else {
      data
    }
    
    ggplot(filtered_data, aes(x = App.Usage.Time..min.day.)) +
      geom_histogram(binwidth = 30, fill = "lightblue", color = "darkblue") +
      labs(
        title = paste("App Usage Time Frequency (Filtered:", input$os_q6, ")"),
        x = "App Usage Time (minutes/day)",
        y = "Frequency"
      ) +
      theme_minimal()
  })
  
  output$app_usage_scatter <- renderPlot({
    filtered_data <- if (input$os_q6 != "All") {
      data %>% filter(Operating.System == input$os_q6)
    } else {
      data
    }
    
    ggplot(filtered_data, aes(x = App.Usage.Time..min.day., y = Number.of.Apps.Installed)) +
      geom_point(alpha = 0.6, color = "blue") +
      labs(
        title = paste("App Usage Time vs Daily App Usage (Filtered:", input$os_q6, ")"),
        x = "App Usage Time (minutes/day)",
        y = "Number of Apps Installed"
      ) +
      theme_minimal()
  })
}