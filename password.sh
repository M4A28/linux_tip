#!/bin/bash

# Function to generate random password
generate_password() {
  local length="${1:-12}"  # Default length is 12 characters
  local charset='!\"#$%&'\''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~'  # Character set for the password
  local password=$(tr -dc "$charset" < /dev/urandom | head -c "$length")
  echo "$password"
}

# Prompt user for password length or use default length
read -p "Enter password length (default is 12): " password_length
if [ -z "$password_length" ]; then
  password_length=12  # Default length if user input is empty
fi

# Generate and display the password
generated_password=$(generate_password "$password_length")
echo "Generated Password: $generated_password"

