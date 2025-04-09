#RMSD for many ligands
df_ETQ <- read.table("ligand_rmsd.dat", header = FALSE, sep = "", stringsAsFactors = FALSE)
df_ETQF <- read.table("new_ligand_1_rmsd_v2.dat", header = FALSE, sep = "", stringsAsFactors = FALSE)
df_ETQA <- read.table("new_ligand_2_rmsd.dat", header = FALSE, sep = "", stringsAsFactors = FALSE)
#Put column names on each dataframe the 1st one is the frame and the 2nd one is the RMSD
colnames(df_ETQ) <- c("Frame", "RMSD")
colnames(df_ETQF) <- c("Frame", "RMSD")
colnames(df_ETQA) <- c("Frame", "RMSD")
df_ETQA <- df_ETQA[1:322,]  
# Add a new column to identify the ligand in each dataframe
df_ETQ$Ligand <- "ETQ"
df_ETQF$Ligand <- "ETQF"
df_ETQA$Ligand <- "ETQA"

# Combine all three dataframes
df_combined <- rbind(df_ETQ, df_ETQF, df_ETQA)

# Load ggplot2
library(ggplot2)

# Plot RMSDs of all three ligands with colorblind-friendly colors
ggplot(df_combined, aes(x = Frame, y = RMSD, color = Ligand)) +
  geom_line(size = 0.6) +  # Line plot for each ligand
  scale_color_manual(values = c("#E69F00", "#CC79A7", "#0072B2")) +  # Orange, Blue, and Purple
  labs(
    title = "RMSD Comparison of Ligands",
    x = "Frame",
    y = "RMSD (Å)",
    color = "Ligand:"
  ) +
  scale_x_continuous(limits = c(0, 330)) +  # X-axis range
  scale_y_continuous(limits = c(0, 3.3)) +  # Y-axis range
  geom_hline(yintercept = seq(0, 3, by = 0.5), color = "gray", linetype = "dashed") +  
  theme_classic() +  # White background
  theme(
    panel.background = element_rect(fill = "white", color = "white"),  
    plot.background = element_rect(fill = "white", color = "white"),
    panel.grid.major = element_blank(),  
    panel.grid.minor = element_blank(),
    legend.position = "top",  # Move legend to the top
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14)  # Center title and make it bold
  )
ggsave("ligand_rmsd_plot.png", width = 8, height = 6, dpi = 300)

