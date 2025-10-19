#!/bin/bash

# Find all .jpg files in ~/.wallpaper
for file in ~/.wallpaper/*.jpg; do
  # Check if any files exist (avoid running on literal "*.jpg" if no files found)
  [ -e "$file" ] || continue

  # Run the wallpaper script
  ~/.config/hypr/helpers/wallpaper.sh "$file"

  # Ask if file should be deleted
  echo ""
  read -p "Delete $(basename "$file")? (y/n): " response

  case "$response" in
  [Yy]*)
    rm "$file"
    echo "Deleted: $file"
    ;;
  *)
    echo "Kept: $file"
    ;;
  esac

  echo "---"
done

echo "Review complete!"
