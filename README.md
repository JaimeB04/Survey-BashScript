# Survey Bash Project

Created a simple bash survey program to test my ability in bash scripting. This survey has essential
features that include registration, login, storing of account credentials like (username, password)
and creation of personalized cvs files based on each user's response.

## Key Features
- User-friendly that runs on a terminal
- Stores user's respondes in a cvs format
- Supports multiple users partipating on the survey
- Lightweight and works on any linux system

## File Structure
# Surver-BashScript/
 |-- survey_app.sh          # Main Bash Script
 |-- question_bank.csv      # Contains survey questions
 |-- user_credentials.csv   # Stores user info
 |-- README.md              # Description of the survery (You're reading it!)

## Try it out!
1. Clone this repository
```bash 
git clone git@github.com:JaimeB04/Survey-BashScript.git
```

2. Move into the project folder
```bash
cd Survey-BashScript
```

3. Make the script executable 
```bash
chmod +x survey_app.sh
```

4. Run it!
```bash 
./survey_app.sh
```
