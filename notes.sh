# TODO - Add readme 
# shellcheck disable=SC2148
# Note script to handle CRUD operations with textfiles with notes to save and delete

# global variables
home_dir=~
file_name=notes.txt
storage_name=YourNotes
PATH_TO=$home_dir/$storage_name
ALL_NOTES=()

# utility functions ->  to get all single information from the note storage strings

# check if the entered index belongs to a note the list
is_valid_index () {
	input_index=$1
	# when the index is equal or bigger than the number of notes -> index not a part of the list
	if [ ! ${#ALL_NOTES[@]} -gt $((input_index - 1)) ]
	then
		return 1
	else
		return 0
	fi 
}

# Cuts the note content out of the string -> Returns the content as a string
get_content () {
	# get the note
	note=$1
	# split the string into a list of the notes properties
	content="$(cut -d'|' -f1 <<<"$note")"
	# return the content string at the index: 0
	echo "$content"
}

# splits the note string into a list of the notes properties
get_id () {
	note=$1
	id="$(cut -d'|' -f3 <<<"$note")"
	echo "$id"
}

# 
get_time () {
	note=$1
	time="$(cut -d'|' -f2 <<<"$note")"
	echo "$time"
}

# Check for a storage directory in the homedirectory of the user
# if not there -> create one
# notify the user where the notes are stored
# if true -> load the files
# list them with an ascending number
check_for_storage () {
	if [ ! -d $home_dir/$storage_name ] #its true when the storage isn't there
	then
		# create the storage
		create_storage	
	else	
		# read and store all notes in 'ALL_NOTES'
		read_storage		
	fi
}

# just adds the storage to the home directory
create_storage () {
	cd $home_dir || exit
	mkdir $storage_name
	cd $storage_name || exit
	touch notes.txt
	echo "Create the storage folder in the home directory under the name: $storage_name ."
}

# proceed to working mode
serve_working_mode () {
	# before showing UI -> load all notes
	# list them
	show_Ui
	# on the bottom show possible actions the user can take
	echo "You have three operation possibilities."
	echo "Create -> 'c' || Modify -> 'm' || Delete -> 'd' || Save Changes -> 's'"
	echo ""
	read -r -p "-> " action_choice
	# for modify and delete the user has to enter the note index in the list
	

	if [ "$action_choice" = "c"  ]
	then 
		serve_create_mode	
	elif [ "$action_choice" = "m" ]
	then
		echo ""
		echo "________________________________________________________________ - Modify -"
		echo ""
		echo "Which note do you want to modify?"
		echo "Please enter the number of the note in the list! Ex.: 3. Note: 'Test' ... => ( ' -> 3 ' in terminal)"
		echo "________________________________________________________________"
		echo ""
		read -r -p "-> " note_index
		
		# check with 'echo $?' which exit code was returne from the checker function
		if is_valid_index "$note_index"
		then
			serve_modify_mode "$((note_index - 1))"
		else 
			serve_working_mode
		fi
	elif [ "$action_choice" = "s" ]
	then
		clear get_
		echo "Saving changes!"
		save_changes
		sleep 2
		clear
		serve_working_mode
	elif [ "$action_choice" = "d" ]
	then
		echo ""
		echo "________________________________________________________________ - Delete -"
		echo ""
		echo "In this menu, you can delete a note."
		echo "You can see all saved and newly created notes above! By entering the number of the note in the list, you can delete it from the list!"
		echo "! To fully delete the note, save your changes in the main menu !"
		echo ""
		echo "________________________________________________________________"
		echo ""
		read -r -p "-> note index : " note_index
		echo ""
		# ask the user to confirm the deletion of the note
		if is_valid_index "$note_index"
		then
			serve_delete_mode "$((note_index - 1))"
		else 
			serve_working_mode
		fi
	else
		serve_working_mode
	fi
}

# we need 3 different modes

# delete a note from the list, ask if the user is sure
serve_delete_mode () {
	# assign index
	index=$1
	# Ask if the user really wants to delete the note
	echo "________________________________________________________________"
	echo ""
	echo "Do you really want to delete this note? [ y / n ]"
	echo ""
	read -r -p "-> " delete_answer
	# depending on the answer: delete || leave the mode
	if [[ "$delete_answer" != "y" && "$delete_answer" != "n" ]]
	then
		clear
		echo "You have to enter a valid answer character 'y' or 'n'!"
		sleep 4
		serve_delete_mode "$index"
	fi

	if [[ "$delete_answer" == "y" ]]
	then
		clear
		echo "Deleting note at index $index in the list ..."
		sleep 4
		delete_note "$index"
		serve_working_mode
	elif [[ "$delete_answer" == "n" ]]
	then
		clear 
		echo "Won't delete the note at index $index!"
		sleep 3
	fi
	serve_working_mode
}

# modify an existing note
serve_modify_mode () {
	# pass the index of the note 
	# -> access the note with it
	index=$1

	# inherits from the selected note
	# will be used to overwrite the note that was selected -> if changes where made
	PreviousNote="${ALL_NOTES[index]}"
	NewNote=""

	# clear vision
	clear
	# give information to the user
	echo "________________________________________________________________ - Modify -"
	echo "Okay so you can the information of the note below."
	echo "Modify the note as you please."

	# two operation opportunities
	# 1 -> cancel & 2 -> save changes
	echo "________________________________________________________________"
	echo "Cancel [1] || Save Changes [2]"
	

	# display the note and save the changes
	
	note_content="$(get_content "$PreviousNote")"
	echo "Previous note: $note_content"

	# Need to iterate over every input char
	# _> could mean a output like this: 
	# -> I
	# -> S
	# -> T

	# Counts how many iterations the user has used for entering the new note
	iterationCount=1

	while true
	do  
		read -r -p "-> $NewNote : " input
		if [ "$input" == "1" ]
		then
			clear
			echo "Skipping modifing note ..."
			sleep 1
			serve_working_mode
			break
		fi

		if [ "$input" == "2" ]
		then
			# the user needs to enter enough characters to modify the note
			if [ ${#NewNote} -lt 1 ]
			then
				clear
				echo "You tried to change to an empty note. Try again!"
				sleep 3
				clear
				serve_modify_mode
				break
			fi

			# add the note to the note list
			# needs to be saved in the working mode
			ALL_NOTES[index]="$(note_string_pattern "$NewNote")"
			clear
			printf "The note was added to the list.\n Saved your changes in the dashboard!"
			sleep 3
			clear
			
			# return back to the main dashboard
			serve_working_mode
			break
		fi
		if [[ ${input:0:1} != " "  &&  "$iterationCount" != "1" ]]
		then
			NewNote+=" ${input}"
		else
			NewNote+=$input
		fi
		iterationCount+=$((iterationCount + 1))
	done

	if [ "$PreviousNote" -eq "$NewNote" ]
	then
		echo "You have entered the same note again. No changes will be made!"
	fi
}

# create mode -> lets the user enter his note
serve_create_mode () {
	# clear the screen
	clear
	echo "________________________________________________________________"
	echo "Here you can enter your new note."
	echo "You can write single parts of the note and press 'Enter' to continue to a opportunity to append on the note."
	echo "Be aware that you need to only enter the operationsymbols in the terminal to chose a actions like this: (Create => '-> 1')"
	# some navigation options
	echo "Cancel [1] || Create [2]"

	noteCharArray=""
	while true
	do 
		read -r -p "-> " input
		# wait
		if [ "$input" == "1" ]
		then
			clear
			echo "Stop creation of note ..."
			sleep 1
			serve_working_mode
			break
		fi

		if [ "$input" == "2" ]
		then
			# the user needs to enter enough characters to save the note
			if [ ${#noteCharArray} -lt 1 ]
			then
				clear
				echo "You tried to create an empty note. Try again!"
				sleep 3
				clear
				serve_create_mode
				break
			fi

			# add the note to the note list
			# needs to be saved in the working mode
			add_note "$noteCharArray"
			clear
			printf "The note was added to the list.\nSaved your changes in the dashboard!"
			sleep 3
			clear
			
			# return back to the main dashboard
			serve_working_mode
			break
		fi
		noteCharArray+=$input
	done
}


# I/O functions for textfiles

# traits: content, time, id
# content|time|id

# general string structure pattern
note_string_pattern () {
	echo "$1|$(date +%c)|$(uuidgen)"
}

# use 'uuidgen' command
add_note () {
	ALL_NOTES+=("$(note_string_pattern "$1")")
}

# reads all lines of the storage file -> creates notes and stores them in a list
read_storage () {
	while read -r line
	do 
		content="$(get_content "$line")"
		time="$(get_time "$line")"
		id="$(get_id "$line")"
		# use variable $Line here to store the notes in a array
		ALL_NOTES+=("$content|$time|$id")		
	done < $PATH_TO/$file_name
}

save_changes () {
	cd $PATH_TO || exit
	# deletes old notes
	: > $file_name 
	for note in "${ALL_NOTES[@]}"
	do
		content="$(get_content "$note")"
		time="$(get_time "$note")"
		id="$(get_id "$note")"
		store_string="$content|$time|$id"		
		echo "$store_string" >> $file_name
	done
}

# Delete a note out of the list by using its index
delete_note () {
	if [ ${#ALL_NOTES[@]} -le 0 ]
	then
		echo "No notes have been found!"
		exit 1 
	fi
	unset "ALL_NOTES[$1]"
	# rearrange the list so that there is no empty index in the list
	# loop over the whole the whole list
	# when a index spot is empty -> move the next note to this empty index
	# when there is no next note -> remove this empty index from the list
	for (( i=0; i<${#ALL_NOTES[@]}; i++ ))
	do 
		if [[ "${ALL_NOTES[$i]}" = "" ]]
		then
			# remove the last index from the list when it is empty
			if [ ${#ALL_NOTES[@]-1} -eq $i ]
			then
				unset "ALL_NOTES[$i]"
				continue
			fi
			# assign the note of the next index to the index before
			ALL_NOTES[i]="${ALL_NOTES[$i+1]}"
			unset "ALL_NOTES[$i+1]"
		fi
	done
}

# https://www.baeldung.com/linux/clear-file-contents
# Delete everything from a file
delete_everything () {
	# cat /dev/null > $home_dir/$storage_name
	# > $PATH_TO/$file_name
	sed -i 'd' $PATH_TO/$file_name
}

# create a navigation system for the user to interact with the script
# -> infinite loop with modifying pattern
# 1)  create / modify / delete
# 2) a) [create] get user's input -> write to storage -> show default UI
#    b)	[modify] select note -> show content which the user can change -> save -> update 'last change'-date -> return to UI
#    c)	[delete] select note -> show content and ask if the user really wants to delete this note -> (true/false) delete OR leave delete-page -> save changes to storage -> return to general UI 
# leaving function -> like press 'q' 


# display UI
show_Ui () {
	clear
	echo "You can see all your created notes here."
	echo ""
	echo "__________________ - Notes - __________________"
	echo ""
	# list them in a kind of table
	note_number=1

	if [ ${#ALL_NOTES[@]} -lt 1 ]
	then
		echo "-- no notes here --"
	else
		for note in "${ALL_NOTES[@]}"
		do 
		content="$(get_content "$note")"
		time="$(get_time "$note")"
		# seperate the storage string (depends on note representation method -> class or a simple string)
		echo "$note_number. Note: '$content' || time: $time"
		# increase the note number
		note_number=$((note_number + 1))
	done
	note_number=1

	fi

	echo "________________________________________________________________"
	echo ""
}

# calling the functions in logical order

# start the app here
entry_point () {
	# check for the storage situation
	check_for_storage
	# show the user interface
	serve_working_mode
}

entry_point