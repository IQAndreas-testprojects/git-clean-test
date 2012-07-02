#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Please specify which test number you want to run (see README.md for help)."
elif [ $1 -lt 0 ]; then
    echo "Invalid test number"
elif [ $1 -gt 3 ]; then
	echo "Invalid test number."
else

	# Remove old files
	rm -rf ignore
	rm -f untracked-file
	
	# Pass 0 to reset everything
	if [ $1 -eq 0 ]; then
		cp reset-files/reset.gitignore .gitignore
	else
		# Add new files
		cp -r reset-files/test$1 ignore
		cp reset-files/untracked-file .
		cp reset-files/test$1.gitignore .gitignore
    fi

fi
