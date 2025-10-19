#!/bin/bash

#Files that will be used

USER_CREDENTIALS_FILE="user_credentials.csv"
QUESTION_BANK_FILE="question_bank.csv"

#Main menu function
main_menu() {
	while true
	do
		clear
		echo "Survey Application: Main Menu"
		echo
		echo -e "\t1. Register"
		echo -e "\t2. Login"
		echo -e "\t3. Exit"
		echo
		read -p "Please choose your option: " choice
		case $choice in
			1) register_user ;;
			2) login_user ;;
			3) exit_program ;;
			*) echo "Invalid option. Please try again." ;;
		esac
		pause
	done
}

pause() {
	read -n1 -r -p "Press any key to continue..." key
}

exit_program() {
	clear
	echo "Thank you for using the Survey Application. Goodbye!"
	exit 0
}

#Register function for the user
register_user() {
	clear
	echo "Survey Application: Registration"
	echo

	touch "$USER_CREDENTIALS_FILE"

	while true
	do
		read -p "Please choose your username: " username

		if ! [[ "$username" =~ ^[a-zA-Z0-9]+$ ]]
		then
			echo "Username should contain only alphanumeric characters."
			continue
		fi

		if grep -q "^$username," "$USER_CREDENTIALS_FILE"
		then
			echo "Username $username exists."
			continue
		fi
		break
	done

	while true
	do
		read -s -p "Please enter your password: " password
		echo
		read -s -p "Please re-enter you password: " password_confirm
		echo
		if [ "$password" != "$password_confirm" ]
		then
			echo "Passwords do not match. Please try again."
			continue
		fi

		if ! [[ ${#password} -ge 8 ]]
		then
			echo "Password must be at least 8 characters logn."
			continue
		fi

		if ! [[ "$password" =~ [0-9] ]]
		then
			echo "Password must contain at least one number."
			continue
		fi
		
		if ! [[ "$password" =~ [\!\@\#\$\%\^\&\*] ]] 
		then
			echo "Password must contain at least one special character."
			continue
		fi
		break
	done

	echo "$username,$password" >> "$USER_CREDENTIALS_FILE"
	echo
	echo "Registration successful."
}

#This is the login part
login_user() {
	clear
	echo "Survey Application: Login"
	echo

	read -p "Username: " username
	read -s -p "Password: " password
	echo

	if grep -q "^$username,$password$" "$USER_CREDENTIALS_FILE"
	then
		echo "Login successful."
		logged_in_menu "$username"
	else
		echo "Invalid username or password."
	fi
}

logged_in_menu() {
	local username="$1"
	while true
	do
		clear
		echo "Survey Application: $username's Survey"
		echo
		echo -e "\t1. Take Survey"
		echo -e "\t2. View Survey"
		echo -e "\t3. Logout"
		echo
		read -p "Please choose your option: " choice
		case $choice in
			1) take_survey "$username" ;;
			2) view_survey "$username" ;;
			3) break;;
			*) echo "Invalid option. Please try again." ;;
		esac
		pause
	done
}

take_survey() {
	local username="$1"
	local answer_file="${username}_answers_file.csv"
	touch "$answer_file"
	> "$answer_file"

	if [ ! -f "$QUESTION_BANK_FILE" ]
	then
		echo "Questions bank file not found!"
		return
	fi

	total_questions=$(wc -l < "$QUESTION_BANK_FILE")

	for (( i=1; i<=total_questions; i++ ))
	do
		clear
		echo "Survey Application: $username's Survey"
		echo

		question_line=$(sed -n "${i}p" "$QUESTION_BANK_FILE")

		question_text=$(echo -e "$question_line" | sed -E 's/^([a-dA-D]\.\s)/\t\1/')
		echo "$question_text"
		echo

		local valid_answer=0
		while [ $valid_answer -eq 0 ]
		do
			read -p "Please choose your option: " answer
			case "$answer" in
				a|b|c|d|A|B|C|D)
					valid_answer=1
					;;
				*)
					echo "Invalid option. Please enter a, b, c, or d."
					;;
			esac
		done

		answered_question=$(echo "$question_line" | sed "s/\($answer\.\s[^\\\\]*\)/\1 -> YOUR ANSWER/")
		echo "$answered_question" >> "$answer_file"
	done

	echo
	echo "Survey complete."
}

view_survey() {
	local username="$1"
	local answer_file="${username}_answers_file.csv"
	if [ ! -f "$answer_file" ]
	then
		echo "You have not taken the survey yet."
		return
	fi

	clear
	echo "Survery Application: $username's survey"
	echo
	echo "Viewing your survey results:"
	echo
	while IFS= read -r line
	do
		line_formatted=$(echo -e "$line" | sed -E 's/^([a-dA-D]\.\s)/\t\1/')	
		echo "$line_formatted"
		echo
	done < "$answer_file"
}

main_menu
