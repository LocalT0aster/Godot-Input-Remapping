#!/bin/bash


file=rsync-source-location.txt

# Check if the file exists
if [ ! -e $file ]; then
    # File doesn't exist, create an empty one
    touch $file
fi

# File exists, read the first line into a variable
read -r source < $file
    
if [ -z "$source" ]; then
    # File is empty, prompt the user for input
    echo "Please enter the source folder (contains project.godot)."
    read -r user_input
    
    # Save user input to the file
    echo "$user_input" > "$file"
    echo "Source saved to $file."
    source="$user_input"
fi


# Source and destination directors
src_dir="$source/addons/maaacks_options_menus/"
dest_dir="../addons/maaacks_input_remapping/"

echo $src_dir
find $src_dir -type d -empty -o -type f -ctime -10 -printf '%P\0' | rsync -av --files-from=- --from0 "$src_dir" "$dest_dir"


# Define strings to replace
finds=("options_menus" "Options Menus" "OptionsMenus" "Options-Menus" "options-menus")
replaces=("input_remapping" "Input Remapping" "InputRemapping" "Input-Remapping" "input-remapping")

# Checks for strings and replaces them
for ((i=0; i<${#finds[@]}; i++)); do
    find="${finds[i]}"
    replace="${replaces[i]}"
    
    # Find and replace in all files in the destination directory
    find "$dest_dir" -type f -exec sed -i "s/${find}/${replace}/g" {} +
done

