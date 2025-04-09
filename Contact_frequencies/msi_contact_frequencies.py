import re
import pandas as pd

# Before running this script, please make sure the pandas library installed
# Also, please change the file_path to accomodate your file

# File path of the .tml from Timeline Tool VMD
file_path = ""

# Variables to store the results
residue_labels = []
contact_frequencies = []

# Read the file
with open(file_path, 'r') as file:
    lines = file.readlines()

# Process the file line by line
current_residue = None
contacts = []

for line in lines:
    # Find residues labels
    if line.startswith("freeSelLabel"):
        # Store the previous frequency, if it exists
        if current_residue and contacts:
            total_frames = len(contacts)
            frequency = sum(contacts) / total_frames  # Relative frequency
            residue_labels.append(current_residue)
            contact_frequencies.append(frequency)

        # Extract the residue name
        current_residue = re.search(r"freeSelLabel (.+)==", line).group(1)
        contacts = []  # Restart the contacts list

    # Capture contact data (0 or 1)
    elif re.match(r"^\d+ \d+", line.strip()):
        frame, contact = map(int, line.split())
        contacts.append(contact)

# Process the last residue
if current_residue and contacts:
    total_frames = len(contacts)
    frequency = sum(contacts) / total_frames
    residue_labels.append(current_residue)
    contact_frequencies.append(frequency)

# Create a dataframe for the results
df = pd.DataFrame({
    "Residue": residue_labels,
    "Contact Frequency": contact_frequencies
})

# Store in a CSV file, specify this path
output_path = ""
df.to_csv(output_path, index=False)

# Show the results
print(df)
