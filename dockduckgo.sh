#  Add duck function to search on DuckDuckGo
duck() {
    open "https://duckduckgo.com/?q=${*// /+}"
}
