#!/bin/sh

YEAR="1998"
read -p "Github Username: " USERNAME

if [ -z "$USERNAME" ]
then
  exit 1
fi

mkdir $YEAR
cd $YEAR
git init
echo "**$YEAR** - Just for fun!" > README.md
git add .
GIT_AUTHOR_DATE="$YEAR-01-01T9:00:00" GIT_COMMITTER_DATE="$YEAR-01-01T9:00:00" git commit -m "feat: fake year history github profile $YEAR"
git remote add origin https://github.com/$USERNAME/hello-world-1998.git
git push -u origin master -f
echo
echo Cool, check your profile now: https://github.com/$USERNAME
