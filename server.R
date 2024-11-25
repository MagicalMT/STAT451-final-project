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
  data <- read.csv("./data/user_behavior_dataset.csv")
  
  data$Age_Group <- cut(
    data$Age,
    breaks = c(18, 28, 38, 48, 60, Inf),
    labels = c("18-28", "29-38", "39-48", "49-60", "60+"),
    right = FALSE
  )
  
  
  ## Question 1
  observe({
    age_groups <- c("None",  unique(as.character(data$Age_Group)))
    updateSelectInput(session, "age_group", choices = age_groups, selected = "None")
  })
  
  output$os_by_age_group <- renderPlot({
    req(input$age_group != "None")  
    
    filtered_data <- data %>%
      filter(Age_Group == input$age_group) %>%
      group_by(Operating.System) %>%
      summarise(Count = n(), .groups = "drop") %>%
      mutate(Percentage = Count / sum(Count) * 100)
    
    ggplot(filtered_data, aes(x = "", y = Percentage, fill = Operating.System)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y") +
      labs(
        title = paste("Operating System Distribution - Age Group:", input$age_group),
        fill = "Operating System"
      ) +
      theme_void() +
      geom_text(aes(label = paste0(round(Percentage, 1), "%")), 
                position = position_stack(vjust = 0.5)) +
      theme(
        plot.title = element_text(size = 18, face = "bold"),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12)
      )
  })
  
  output$os_analysis <- renderText({
    req(input$age_group != "None")
    filtered_data <- data %>%
      filter(Age_Group == input$age_group) %>%
      group_by(Operating.System) %>%
      summarise(Count = n(), .groups = "drop") %>%
      mutate(Percentage = Count / sum(Count) * 100)
    
    analysis <- paste0(
      "For the age group ", input$age_group, 
      ", the majority of users use ", 
      filtered_data$Operating.System[which.max(filtered_data$Percentage)], 
      " with ", round(max(filtered_data$Percentage), 1), 
      "% of the total. The other operating systems have the following distributions: ", 
      paste(filtered_data$Operating.System[-which.max(filtered_data$Percentage)], 
            "(", round(filtered_data$Percentage[-which.max(filtered_data$Percentage)], 1), "%)", 
            collapse = ", "), "."
    )
    return(analysis)
  })
  
  
  ## Question 2
  output$screen_time_plot <- renderPlot({
    req(input$gender_q2 != "None")
    
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
        theme_minimal() +
        theme(
          plot.title = element_text(size = 18, face = "bold"),
          axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.title = element_text(size = 14),
          legend.text = element_text(size = 12)
        )
      
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
        theme_minimal() +
        theme(
          plot.title = element_text(size = 16, face = "bold"),
          axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.title = element_text(size = 14),
          legend.text = element_text(size = 12)
        )
    }
  })
  
  output$screen_time_analysis <- renderText({
    req(input$gender_q2 != "None")
    
    if (input$gender_q2 == "Both (Combined)") {
      analysis <- paste0(
        "This graph shows the average screen on time by age, combining data for both genders. ",
        "The trend line (loess smooth) indicates how screen time fluctuates with age. ",
        "For example, the average screen time starts around 5 hours per day, dips slightly in the mid-30s, ",
        "and then gradually stabilizes as age increases. "
      )
    } else {
      analysis <- paste0(
        "This graph shows the average screen on time by age for ", input$gender_q2, ". ",
        "The trend line (loess smooth) highlights how screen time changes across different ages. ",
        "For instance, specific patterns in screen usage can be observed among ", input$gender_q2, 
        ", such as potential dips or rises in screen time at certain age ranges."
      )
    }
    
    return(analysis)
  })
  
  
  ## Question 3
  observe({
    variable_choices <- colnames(data)[sapply(data, is.numeric)]
    updateSelectInput(session, "vars_q3", choices = variable_choices, selected = variable_choices[1:4])
  })
  
  output$correlation_plot <- renderPlot({
    req(length(input$vars_q3) >= 2)
    correlation_data <- data %>% select(all_of(input$vars_q3))
    colnames(correlation_data) <- gsub("\\.\\.+", ".", colnames(correlation_data))
    
    correlation_matrix <- cor(correlation_data, use = "complete.obs")
    
    corrplot(
      correlation_matrix,
      method = "color",
      type = "upper",
      tl.col = "black",
      tl.cex = 1,
      tl.srt = 45,
      title = NULL,
      addCoef.col = "red",
      number.cex = 0.8
    )
    
    mtext("Correlation Matrix: App Usage Time vs Number of Apps", 
          side = 3, line = 2, adj = 0, cex = 1.5, font = 2)
  })
  
  
  output$correlation_analysis <- renderText({
    req(length(input$vars_q3) >= 2)
    selected_vars <- paste(input$vars_q3, collapse = ", ")
    
    analysis <- paste(
      "This correlation matrix reveals strong interconnections between app usage time, screen-on time, ",
      "and the number of apps installed. Specifically, app usage time has a very high positive correlation ",
      "with both screen-on time and the number of apps installed, indicating that users who install more apps ",
      "tend to spend more time using them and consequently keep their screens on longer. ",
      "However, age shows almost no correlation with these variables, likely because the dataset was not sampled randomly, ",
      "but rather represents averages across all age groups. ",
      "We use a correlation matrix plot here because it provides a clear overview of the correlation ",
      "between multiple variables in a single visualization."
    )
    return(analysis)
  })
  
  ## Question 4
  observe({
    age_groups <- c(unique(data$Age_Group))
    updateSelectInput(session, "age_groups_q4", choices = age_groups, selected = age_groups)
  })
  
  output$app_usage_boxplot <- renderPlot({
    
    filtered_data <- data %>% filter(Age_Group %in% input$age_groups_q4)
    ggplot(filtered_data, aes(x = Age_Group, y = App.Usage.Time..min.day., fill = Age_Group)) +
      geom_boxplot(outlier.color = "red", outlier.shape = 1) +
      scale_fill_brewer(palette = "Set3") +
      labs(
        title = "Distribution of App Usage Time Across Selected Age Groups",
        x = "Age Group",
        y = "Daily App Usage Time (minutes)"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 18, face = "bold"),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12)
      )
  })
  
  
  output$q4 <- renderText({
    req(input$age_groups_q4 != "None")
    
    analysis <- paste(
      "The boxplot illustrates the daily app usage time across different age groups. Interestingly, all the age groups exhibit similar trends in their app usage behavior. Specifically:",
      "\n1. Median Usage: The median daily app usage time remains consistent across all groups, approximately centered around 200 minutes.",
      "\n2. Spread of Data: The interquartile range (IQR), representing the middle 50% of the data, is quite comparable for all age groups, indicating that the majority of users in each group have similar app usage habits.",
      "\n3. Outliers: Outliers appear at both ends of the spectrum, but their presence is consistent across age groups, suggesting similar variations in extreme behaviors.",
      "\n4. Range: The maximum and minimum values show minimal variation among groups, further reinforcing the observation that app usage patterns do not vary significantly with age."
    )
    
    return(analysis)
  })
  
  
  

  ## Question 5
  observe({
    os_choices <- c("None", "All", unique(data$Operating.System))
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
      theme(legend.position = "none") +
      theme(
        plot.title = element_text(size = 18, face = "bold"),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12)
      )
  })
  
  output$screen_time_os_analysis <- renderText({
    paste(
      "The boxplot illustrates the distribution of screen-on time for Android and iOS users.",
      "Both operating systems show a similar median screen-on time, with comparable ranges.",
      "This suggests that users of Android and iOS devices engage with their screens for approximately equal durations on average."
    )
  })
  
  ## Question 6
  observe({
    os_choices <- c("None","All", unique(data$Operating.System))
    updateSelectInput(session, "os_q6", choices = os_choices, selected = "All")
  })
  
  output$app_usage_hist <- renderPlot({
    req(input$os_q6 != "None")
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
    req(input$os_q6 != "None")
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
      theme_minimal()+
      theme(
        plot.title = element_text(size = 18, face = "bold"),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12)
      )
  })
  
  output$app_usage_analysis <- renderText({
    req(input$os_q6 != "None")
    analysis <- paste(
      "For the all category, we can find this scatterplot illustrates the relationship between 'daily app usage' and the 'number of installed apps.' ",
      "However, the data displays an unusually consistent stepwise pattern, which is highly irregular in real-world scenarios. ",
      "This uniform distribution suggests that the dataset may not represent actual user behavior but rather a synthetic dataset intended for demonstration or testing purposes.",
      "\n\nFurthermore, the absence of noise, irregular fluctuations, or outliers—common in real-world datasets—further strengthens the suspicion that this data is artificially generated. ",
      "Real-world data typically exhibits variability due to diverse user behaviors, environmental factors, and data collection inconsistencies, all of which appear to be missing in this dataset."
    )
    
    return(analysis)
  })
}
