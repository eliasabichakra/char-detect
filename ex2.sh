#!/bin/bash

# to list all usb
list_usb_devices() {
  lsusb
}

# Directory li bdna naamil monitoring fya
dir_to_monitor="/home/elias/name_dir" 

# local krmel a3mil limit lal varable bi zet l function
# -gt yaaneh greater than
# $1 huwe the first argument
has_more_than_5_characters() {
  local name="$1"
  if [ ${#name} -gt 5 ]; then
    return 0  # Return success (true)
  else
    return 1  # Return failure (false)
  fi
}

# -r prevent the / yaaneh eza ken aandeh msln /n ma bynzl aal sater
# wl read to read the content of file line by line 
# wl < $file enno l read rah to2ra mn l file
process_usb_name_file() {
  local file="$1"
  while read -r name; do
    if has_more_than_5_characters "$name"; then
      echo "Name with more than 5 characters: $name"
    fi
  done < "$file"
}

# hyde krmel ma yaamil search abel ma hott l usb
searching=false

# Infinite loop
while true; do
  # Get the current list of USB devices
  current_list=$(list_usb_devices)

  # If the initial list is empty, set it to the current list
  # -z yaaneh if l initial list is empty 
  if [ -z "$initial_list" ]; then
    initial_list="$current_list"
  fi

  # Use diff to find differences between the lists
  diff_output=$(diff <(echo "$initial_list") <(echo "$current_list"))

  # Check if there are differences
  # -n yaaneh if the diif_output is not empty
  if [ -n "$diff_output" ]; then
    echo "USB device change detected:"
    echo "$diff_output"

    # bi ballish searching when the usb is detected
    searching=true
  fi

  # -e to check if the file or dir is exist
  if [ "$searching" = true ]; then
    for file in "$dir_to_monitor/"name*; do
      if [ -e "$file" ]; then
        process_usb_name_file "$file"
      fi
    done
  fi

  # Update the initial list to match the current list
  initial_list="$current_list"

  sleep 5  # Delay between checks (in seconds)
done
