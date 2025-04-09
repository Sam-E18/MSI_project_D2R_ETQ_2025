#Interselection contacts after python script
df_ETQ <- read.table("ligand_contacts_v1.csv", header = TRUE, sep = ",")
df_ETQF <- read.table("new_ligand_1_contacts_v2.csv", header = TRUE, sep = ",")
df_ETQA <- read.table("new_ligand_2_contacts.csv", header = TRUE, sep = ",")
# Add a new column to identify each ligand
df_ETQ$Ligand <- "ETQ"
df_ETQF$Ligand <- "ETQF"
df_ETQA$Ligand <- "ETQA"
library(ggplot2)
# Combine all three data frames
df_combined <- rbind(df_ETQ, df_ETQF, df_ETQA)

# Plot the contact frequencies for all ligands
ggplot(df_combined, aes(x = reorder(Residue, -Contact.Frequency), y = Contact.Frequency, fill = Ligand)) +
  geom_bar(stat = "identity", position = "dodge") +  # "dodge" separates bars by Ligand
  theme_bw() +
  labs(x = "Residue", y = "Average Contact Frequency", title = "Residue vs Contact Frequency") +
  theme(
    axis.text.x = element_text(angle = 70, hjust = 1),
    plot.title = element_text(hjust = 0.5)  # Centers the title
  ) +
  scale_fill_manual(values = c("ETQ" = "#E69F00", "ETQF" = "#0072B2", "ETQA" = "#CC79A7"))
ggsave("barplot.png", width = 10, height = 6, dpi = 300)
#horisontal
ggplot(df_combined, aes(x = reorder(Residue, Contact.Frequency), y = Contact.Frequency, fill = Ligand)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +  # Flips the axes
  theme_bw() +
  labs(x = "Residue", y = "Average Contact Frequency", title = "Residue vs Contact Frequency") +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "top"
  ) +
  scale_fill_manual(values = c("ETQ" = "#E69F00", "ETQF" = "#0072B2", "ETQA" = "#CC79A7"))
ggsave("barplot_horizontal.png", width = 10, height = 6, dpi = 300)
#boxplot
ggplot(df_combined, aes(x = Ligand, y = Contact.Frequency, fill = Ligand)) +
  geom_boxplot() +
  theme_minimal() +
  labs(x = "Ligand", y = "Average Contact Frequency", title = "Ligand vs Contact Frequency") +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "none"
  ) +
  scale_fill_manual(values = c("ETQ" = "#E69F00", "ETQF" = "#0072B2", "ETQA" = "#CC79A7"))
ggsave("boxplot.png", width = 6, height = 4, dpi = 300, bg = "white")
#Show the mean on boxplots
ggplot(df_combined, aes(x = Ligand, y = Contact.Frequency, fill = Ligand)) +
  geom_boxplot() +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "white") +
  theme_minimal() +
  labs(x = "Ligand", y = "Average Contact Frequency", title = "Ligand vs Contact Frequency") +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "none"
  ) +
  scale_fill_manual(values = c("ETQ" = "#E69F00", "ETQF" = "#0072B2", "ETQA" = "#CC79A7"))
ggsave("boxplot_mean.png", width = 6, height = 4, dpi = 300, bg = "white")
#heatmap white backround

ggplot(df_combined, aes(x = Ligand, y = Residue, fill = Contact.Frequency)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "magenta3") +
  theme_classic() +  # White background with no gridlines
  labs(x = "Ligand", y = "Residue", title = "Heatmap of Contact Frequencies") +
  theme(
    axis.text.x = element_text(angle = 70, hjust = 1),
    plot.title = element_text(hjust = 0.5)
  )
ggsave("heatmap.png", width = 10, height = 6, dpi = 300)
#Ordered heatmap
ggplot(df_combined, aes(x = Ligand, y = reorder(Residue, Contact.Frequency, FUN = sum), fill = Contact.Frequency)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "magenta3") +
  theme_classic() +  # White background with no gridlines
  labs(x = "Ligand", y = "Residue", title = "Heatmap of Contact Frequencies") +
  theme(
    axis.text.x = element_text(angle = 70, hjust = 1),
    plot.title = element_text(hjust = 0.5)
  )

ggsave("heatmap_ORDER.png", width = 10, height = 6, dpi = 300)
#load packages
library(ggplot2)
library(dplyr)
#Show which residues  exist in ETQF and not exist in ETQ
df_ETQF_not_ETQ <- df_ETQF %>%
  anti_join(df_ETQ, by = "Residue")
#Show which residues exist in ETQ and not exist in ETQF
df_ETQ_not_ETQF <- df_ETQ %>%
  anti_join(df_ETQF, by = "Residue")
####In ETQF we create 2 new contacts and loose 6
#Show which residues exist in ETQ and not exist in ETQA
df_ETQ_not_ETQA <- df_ETQ %>%
  anti_join(df_ETQA, by = "Residue")
#Show which residues exist in ETQA and not exist in ETQ
df_ETQA_not_ETQ <- df_ETQA %>%
  anti_join(df_ETQ, by = "Residue")
#In ETQA we create 2 contacts (same as ETQF) we loose 5
#Compare numerically the contact frequencies between ETQ ETQF ETQA
library(dplyr)
df_combined %>%
  group_by(Ligand) %>%
  summarise(mean_contact_frequency = mean(Contact.Frequency))
# ETQ 276, ETQF 271, ETQA 262 