library(e1071)
library(ggplot2)
library(dplyr)
library(reshape2)
library(caret)

# Load dataset
data <- read.csv("E:\\Pulsar-Signal-Analysis\\pulsarDataa.csv")

# Define the menu function
run_menu <- function() {
  cat("\nMain Menu:\n")
  cat("1. View Descriptive Statistics\n")
  cat("2. Time Domain Analysis (Statistics)\n")
  cat("3. Plot Signals\n")
  cat("4. Calculate and View Signal Features\n")
  cat("5. Visualize Outliers\n")
  cat("6. Plot Feature Distributions\n")
  cat("7. Correlation Analysis\n")
  cat("8. Apply Fourier Transform\n")
  cat("9. PCA (Dimensionality Reduction)\n")
  cat("10. ANOVA (Comparing the means of 'Mean of the integrated pulse profile' across 'target_class')\n")
  cat("0. Exit\n")
  choice <- as.integer(readline(prompt = "Choose an option: "))
  return(choice)
}

# Menu loop
repeat {
  choice <- run_menu()
  
  if (is.na(choice)) {
    cat("Invalid input. Please enter a valid number.\n")
    next  # Go back to menu if invalid input is entered
  }
  
  if (choice == 0) {
    cat("Exiting the program...\n")
    break
  }
  
  switch(as.character(choice),
         
         # Option 1: Descriptive Statistics
         "1" = {
           descriptive_stats <- data.frame(
             Feature = colnames(data),
             Mean = sapply(data, function(x) if (is.numeric(x)) mean(x, na.rm = TRUE) else NA),
             Median = sapply(data, function(x) if (is.numeric(x)) median(x, na.rm = TRUE) else NA),
             Std_Dev = sapply(data, function(x) if (is.numeric(x)) sd(x, na.rm = TRUE) else NA),
             Skewness = sapply(data, function(x) if (is.numeric(x)) skewness(x, na.rm = TRUE) else NA),
             Kurtosis = sapply(data, function(x) if (is.numeric(x)) kurtosis(x, na.rm = TRUE) else NA)
           )
           print("Descriptive Statistics:")
           print(descriptive_stats)
         },
         
         # Option 2: Time Domain Analysis (Statistics)
         "2" = {
           data$Time_Index <- seq_along(data$Mean.of.the.integrated.profile)
           
           time_domain_stats <- function(signal) {
             mean_val <- mean(signal)
             variance_val <- var(signal)
             rms_val <- sqrt(mean(signal^2))
             
             stats <- data.frame(
               Mean = mean_val,
               Variance = variance_val,
               RMS = rms_val
             )
             return(stats)
           }
           
           integrated_stats <- time_domain_stats(data$Mean.of.the.integrated.profile)
           dm_snr_stats <- time_domain_stats(data$Mean.of.the.DM.SNR.curve)
           
           cat("Integrated Profile Statistics:\n")
           print(integrated_stats)
           cat("\nDM-SNR Curve Statistics:\n")
           print(dm_snr_stats)
         },
         
         # Option 3: Plot Signals
         "3" = {
           data$Time_Index <- seq_along(data$Mean.of.the.integrated.profile)
           plot_signal <- function(data, signal, title) {
             if (!signal %in% names(data)) {
               stop(paste("Signal", signal, "not found in the dataset."))
             }
             
             p <- ggplot(data, aes(x = Time_Index, y = !!sym(signal))) +
               geom_line(color = "blue") +
               labs(title = title, x = "Time (Index)", y = "Amplitude") +
               theme_minimal()
             
             print(p)
           }
           
           cat("Plotting Integrated Profile...\n")
           plot_signal(data, "Mean.of.the.integrated.profile", "Integrated Profile over Time")
           
           cat("Plotting DM-SNR Curve...\n")
           plot_signal(data, "Mean.of.the.DM.SNR.curve", "DM-SNR Curve over Time")
         },
         
         # Option 4: Calculate and View Signal Features
         "4" = {
           signal_features <- function(signal) {
             peak_amplitude <- max(signal)
             energy <- sum(signal^2)
             duration <- length(signal)
             
             features <- data.frame(
               Peak_Amplitude = peak_amplitude,
               Energy = energy,
               Duration = duration
             )
             return(features)
           }
           
           integrated_features <- signal_features(data$Mean.of.the.integrated.profile)
           dm_snr_features <- signal_features(data$Mean.of.the.DM.SNR.curve)
           
           cat("Integrated Profile Features:\n")
           print(integrated_features)
           cat("\nDM-SNR Curve Features:\n")
           print(dm_snr_features)
         },
         
         # Option 5: Visualize Outliers
         "5" = {
           visualize_outliers <- function(data) {
             features <- names(data)[-1]
             
             for (feature in features) {
               clean_data <- data[is.finite(data[[feature]]), ]
               p <- ggplot(clean_data, aes_string(y = feature)) +
                 geom_boxplot(fill = "lightblue") +
                 labs(title = paste("Boxplot of", feature), y = feature) +
                 theme_minimal() +
                 theme(plot.title = element_text(hjust = 0.5))
               print(p)
             }
           }
           visualize_outliers(data)
         },
         
         # Option 6: Plot Feature Distributions
         "6" = {
           plot_feature_distribution <- function(data) {
             features <- names(data)[-1]
             
             for (feature in features) {
               clean_data <- data[is.finite(data[[feature]]), ]
               p <- ggplot(clean_data, aes_string(x = feature)) +
                 geom_histogram(bins = 30, fill = "blue", alpha = 0.7, color = "black") +
                 labs(title = paste("Distribution of", feature), x = feature, y = "Frequency") +
                 theme_minimal() +
                 theme(plot.title = element_text(hjust = 0.5))
               print(p)
             }
           }
           plot_feature_distribution(data)
         },
         
         # Option 7: Correlation Analysis
         "7" = {
           correlation_analysis <- function(data) {
             # Create a correlation matrix excluding the first column (if it's not numeric)
             correlation_matrix <- cor(data[-1], use = "pairwise.complete.obs")
             
             # Melt the correlation matrix to long format for ggplot
             melted_corr <- melt(correlation_matrix)
             
             # Create the ggplot object
             p <- ggplot(melted_corr, aes(Var1, Var2, fill = value)) +
               geom_tile() +
               scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                                    midpoint = 0, limit = c(-1, 1), name = "Correlation") +
               theme_minimal() +
               labs(title = "Correlation Heatmap") +
               theme(axis.text.x = element_text(angle = 45, hjust = 1))
             
             # Print the plot explicitly
             print(p)
           }
           
           # Call the correlation analysis function
           correlation_analysis(data)
         },
         
         # Option 8: Apply Fourier Transform
         "8" = {
           apply_fourier_transform <- function(signal, sampling_rate = 1) {
             # Step 1: Perform Fourier Transform
             ft_result <- fft(signal)
             
             # Step 2: Compute frequency and amplitude spectrum
             n <- length(signal)
             frequency <- seq(0, (n - 1) * sampling_rate / n, length.out = n)
             
             # Step 3: Get the magnitude (modulus) of complex numbers to plot amplitude spectrum
             amplitude <- Mod(ft_result)
             
             # Step 4: Focus on the first half of the frequency range (Nyquist frequency)
             half_n <- floor(n / 2)
             frequency <- frequency[1:half_n]
             amplitude <- amplitude[1:half_n]
             
             # Step 5: Create a data frame for the frequency and amplitude
             ft_df <- data.frame(Frequency = frequency, Amplitude = amplitude)
             
             # Step 6: Print the first few values of the Fourier transform for inspection
             cat("First 10 Fourier coefficients and corresponding frequencies:\n")
             print(head(ft_df, 10))
             
             # Step 7: Plot the amplitude spectrum
             p <- ggplot(ft_df, aes(x = Frequency, y = Amplitude)) +
               geom_line(color = "blue") +
               scale_y_log10() +  # Logarithmic scale to highlight smaller frequencies
               labs(title = "Fourier Transform - Amplitude Spectrum", x = "Frequency (Hz)", y = "Log(Amplitude)") +
               theme_minimal()
             
             # Step 8: Print the plot
             print(p)
           }
           
           cat("Applying Fourier Transform on Integrated Profile...\n")
           apply_fourier_transform(data$Mean.of.the.integrated.profile)
         },
         
         
         # Option 9: PCA (Dimensionality Reduction)
         "9" = {
           clean_data <- function(data) {
             clean_data <- data %>% filter_all(all_vars(is.finite(.))) %>% na.omit()
             return(clean_data)
           }
           
           standardize_data <- function(data) {
             numeric_data <- data %>% select_if(is.numeric)
             non_numeric_data <- data %>% select_if(~!is.numeric(.))
             scaled_data <- scale(numeric_data)
             transformed_data <- cbind(non_numeric_data, as.data.frame(scaled_data))
             return(transformed_data)
           }
           
           perform_pca <- function(data, n_components = 2) {
             numeric_data <- data %>% select_if(is.numeric)
             pca_model <- prcomp(numeric_data, center = TRUE, scale. = TRUE)
             print(summary(pca_model))
             pca_data <- as.data.frame(pca_model$x)
             pca_data <- pca_data[, 1:n_components]
             
             p <- ggplot(pca_data, aes(x = PC1, y = PC2)) +
               geom_point(color = "blue", alpha = 0.6) +
               labs(title = "PCA: First Two Principal Components", x = "PC1", y = "PC2") +
               theme_minimal()
             print(p)
           }
           
           cleaned_data <- clean_data(data)
           normalized_data <- standardize_data(cleaned_data)
           perform_pca(normalized_data, n_components = 2)
         },
         "10" = {

                      # 1. ANOVA: Comparing the means of 'Mean of the integrated pulse profile' across 'target_class'
                      data$profile_group <- cut(data$Mean.of.the.integrated.profile, 
                                                breaks = quantile(data$Mean.of.the.integrated.profile, probs = seq(0, 1, by = 0.33), na.rm = TRUE), 
                                                include.lowest = TRUE, 
                                                labels = c("Low", "Medium", "High"))
                      
                      # Perform ANOVA
                      anova_result <- aov(Standard.deviation.of.the.DM.SNR.curve ~ profile_group, data = data)
                      p_value <- summary(anova_result)[[1]][["Pr(>F)"]][1]
                      
                      if (p_value < 0.05) {
                        cat("The null hypothesis (H₀) is rejected: There is a significant difference in means across the groups.\n")
                      } else {
                        cat("The null hypothesis (H₀) is accepted: There is no significant difference in means across the groups.\n")
                      }
         },
         {
           cat("Invalid option. Please try again.\n")
         }
  )
}
