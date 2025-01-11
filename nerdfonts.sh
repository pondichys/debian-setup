#!/usr/bin/env bash

# List of desired fonts (add/modify as needed)
FONTS=(
  "FiraCode"
  "Hack"
  "JetBrainsMono"
)


# Get the latest release tag using GitHub API
get_latest_release_tag() {
  local tag=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" |
                 jq -r '.tag_name')
  if [[ -z "$tag" ]]; then
    echo "Error: Could not fetch latest release tag." >&2
    return 1
  fi
  echo "$tag"
}

# Download a single font
download_font() {
  local font_name="$1"
  local release_tag="$2"
  local download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${release_tag}/${font_name}.zip"

  echo "Downloading: $font_name"
  if wget -q --show-progress "$download_url" -O "$HOME/Downloads/$font_name"; then
     echo "Successfully downloaded: $font_name"
   else
     echo "Error: Failed to download: $font_name" >&2
   fi
}

# Main execution
main() {
    local latest_tag
    latest_tag=$(get_latest_release_tag)
    if [[ $? -ne 0 ]]; then
        echo "Aborting." >&2
        return 1
    fi

    echo "Latest release tag: $latest_tag"

    if [ ! -d $HOME/.local/share/fonts ]; then
      mkdir -pv $HOME/.local/share/fonts 
    fi
    # Download the listed fonts
    for font in "${FONTS[@]}"; do
      download_font "$font" "$latest_tag"
    done

    echo "All downloads complete. Fonts are in the $HOME/Downloads directory."
}

main
