# Commit message: Add len function to calculate the length of a string
len() {
    # Check if argument is provided
    if [ ! -z "$1" ]; then
        # Output the length of the string
        echo "${#1}"
    fi
}
