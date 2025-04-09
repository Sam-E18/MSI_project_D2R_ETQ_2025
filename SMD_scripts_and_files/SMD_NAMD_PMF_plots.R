install.packages("ggplot2")

library(ggplot2)
library(readr)
library(dplyr)
library(tidyr)

# read the CSV process (asegúrate que se llama "da_smd_tcl_3_processed.csv" y está en el directorio de trabajo)
data <- read.csv("da_smd_tcl_3_processed.csv")
data <- data[,1:3]


# Plot the ETQ_F curve (blue)
ggplot(data, aes(x = t, y = z, color = "ETQ_F")) +
  geom_line(size = 1) +
  labs(
    x = "Time (ps)",
    y = "Distance (Å)",
    title = "Extension Curve for ETQ_F",
    color = "Legend"
  ) +
  scale_color_manual(values = c("ETQ_F" = "blue")) +
  theme_minimal(base_size = 14)

# Define pulling parameters (adjust these as per your simulation)
v <- 0.002   # pulling velocity in Å/timestep (from your Tcl code)
dt <- 0.1    # timestep in ps (for example; adjust if needed)

# Calculate the work (PMF) using cumulative sum: work = sum(f * v * dt)
df <- data %>% mutate(f = abs(f))
df <- df %>% mutate(z = abs(z))

df <- df %>% mutate(work = cumsum(f * v * dt))


# Plot the PMF: Work versus Extension
pmf_plot <- ggplot(df, aes(x = z, y = work)) +
  geom_line(color = "deepskyblue3", size = 1) +
  labs(title = "PMF Curve: Work vs. Extension",
       x = "Extension (Å)",
       y = "Work (kcal/mol)") +
  theme_minimal(base_size = 14)

# Display the plot
print(pmf_plot)
