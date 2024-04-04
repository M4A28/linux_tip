# Commit message: Update ex function to extract various compressed file formats and prompt user to install extraction programs if not found
ex() {
  # Check if the argument is a valid file
  if [ -f "$1" ] ; then
    # Extract based on file extension
    case "$1" in
      *.tar.bz2|*.tbz2)    command -v tar >/dev/null 2>&1 && tar xjf "$1" || { echo >&2 "tar is required but it's not installed. To install, run: sudo apt-get install tar"; return 1; } ;;
      *.tar.gz|*.tgz)      command -v tar >/dev/null 2>&1 && tar xzf "$1" || { echo >&2 "tar is required but it's not installed. To install, run: sudo apt-get install tar"; return 1; } ;;
      *.tar.xz|*.txz)      command -v tar >/dev/null 2>&1 && tar Jxvf "$1" || { echo >&2 "tar is required but it's not installed. To install, run: sudo apt-get install tar"; return 1; } ;;
      *.bz2)               command -v bunzip2 >/dev/null 2>&1 && bunzip2 "$1" || { echo >&2 "bunzip2 is required but it's not installed. To install, run: sudo apt-get install bzip2"; return 1; } ;;
      *.rar)               command -v unrar >/dev/null 2>&1 && unrar x "$1" || { echo >&2 "unrar is required but it's not installed. To install, run: sudo apt-get install unrar"; return 1; } ;;
      *.gz)                command -v gunzip >/dev/null 2>&1 && gunzip "$1" || { echo >&2 "gunzip is required but it's not installed. To install, run: sudo apt-get install gzip"; return 1; } ;;
      *.tar)               command -v tar >/dev/null 2>&1 && tar xf "$1" || { echo >&2 "tar is required but it's not installed. To install, run: sudo apt-get install tar"; return 1; } ;;
      *.zip)               command -v unzip >/dev/null 2>&1 && unzip "$1" || { echo >&2 "unzip is required but it's not installed. To install, run: sudo apt-get install unzip"; return 1; } ;;
      *.7z)                command -v 7z >/dev/null 2>&1 && 7z x "$1" || { echo >&2 "p7zip is required but it's not installed. To install, run: sudo apt-get install p7zip-full"; return 1; } ;;
      *.xz)                command -v unxz >/dev/null 2>&1 && unxz "$1" || { echo >&2 "unxz is required but it's not installed. To install, run: sudo apt-get install xz-utils"; return 1; } ;;
      *.tar.lz|*.tlz)      command -v tar >/dev/null 2>&1 && tar --lzip -xf "$1" || { echo >&2 "tar with lzip support is required but it's not installed. To install, run: sudo apt-get install tar"; return 1; } ;;
      *.lz)                command -v lzip >/dev/null 2>&1 && lzip -d "$1" || { echo >&2 "lzip is required but it's not installed. To install, run: sudo apt-get install lzip"; return 1; } ;;
      *.Z)                 command -v uncompress >/dev/null 2>&1 && uncompress "$1" || { echo >&2 "compress is required but it's not installed. To install, run: sudo apt-get install ncompress"; return 1; } ;;
      *.lzma)              command -v unlzma >/dev/null 2>&1 && unlzma "$1" || { echo >&2 "lzma is required but it's not installed. To install, run: sudo apt-get install lzma"; return 1; } ;;
      *.lz4)               command -v lz4 >/dev/null 2>&1 && lz4 -d "$1" || { echo >&2 "lz4 is required but it's not installed. To install, run: sudo apt-get install lz4"; return 1; } ;;
      *.lzo)               command -v lzop >/dev/null 2>&1 && lzop -d "$1" || { echo >&2 "lzop is required but it's not installed. To install, run: sudo apt-get install lzop"; return 1; } ;;
      *.rz)                command -v rzip >/dev/null 2>&1 && rzip -d "$1" || { echo >&2 "rzip is required but it's not installed. To install, run: sudo apt-get install rzip"; return 1; } ;;
      *.tar.zst)           command -v tar >/dev/null 2>&1 && tar --zstd -xf "$1" || { echo >&2 "tar with zstd support is required but it's not installed. To install, run: sudo apt-get install tar"; return 1; } ;;
      *.zst)               command -v unzstd >/dev/null 2>&1 && unzstd "$1" || { echo >&2 "unzstd is required but it's not installed. To install, run: sudo apt-get install zstd"; return 1; } ;;
      *)                    echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
