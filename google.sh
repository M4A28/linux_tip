
# Add google function to search on Google
google() {
    open "https://www.google.com/search?q=${*// /+}"
}
