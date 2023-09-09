# scripts in the redirect file

import os

# Define the base folders
linux_folder = "scripts/linux"
win_folder = "scripts/win"

# Function to generate redirect entries
def generate_redirects_entries(folder_path, prefix):
    entries = []
    for root, dirs, files in os.walk(folder_path):
        for filename in files:
            filepath = os.path.join(root, filename)
            relative_path = os.path.relpath(filepath, folder_path)
            # Remove the file extension from the first name
            name_without_extension = os.path.splitext(relative_path)[0]
            redirect_entry = f"/s/{prefix}/{name_without_extension} /{filepath} 308"
            entries.append(redirect_entry)
    return entries

# Generate redirect entries for Linux
linux_redirects_entries = generate_redirects_entries(linux_folder, "l")

# Generate redirect entries for Windows
win_redirects_entries = generate_redirects_entries(win_folder, "w")

# Add a custom entry
custom_entry = "/ /README.md 308"

# Write the entries to the _redirects file, including comments to separate lists
with open("_redirects", "w") as redirect_file:
    redirect_file.write("# Redirect entries for Linux:\n")
    redirect_file.write("\n".join(linux_redirects_entries))
    redirect_file.write("\n\n# Redirect entries for Windows:\n")
    redirect_file.write("\n".join(win_redirects_entries))
    redirect_file.write("\n\n# Custom redirect entry:\n")
    redirect_file.write(custom_entry)

print("Redirect entries generated and written to _redirects file.")
