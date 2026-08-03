# File containing Git repository links
file="links.txt"

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File $file not found."
    exit 1
fi


# Loop through each repository link in the file and clone it
while IFS= read -r repo_link; do
    echo "Cloning repository: $repo_link"
    git clone "$repo_link"
    echo "Done cloning repository: $repo_link"
    echo ""
done < "$file"
