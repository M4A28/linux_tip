# Commit message: Add mkcd function for creating a directory and moving to it
mkcd() {
    # Check if argument is provided
    if [ ! -z "$1" ]; then
        # Create directory if it doesn't exist and move to it
        mkdir -p "$1" && cd "$_"
    fi
}
