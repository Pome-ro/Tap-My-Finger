# 👉 Tap My Finger
Use this PS1 file in your profile to get updates from users via Finger and check on their status automatically

## Commands
There are a handful of commands in this script. 

### Finger-Someone
Fingers a users account and stores any nwe content within `~\fingered\user@host`

### Tap-Someone
Adds a user to your finger subscriptions stored in `~\fingered\taplist.csv`
returns the content of your tap list (maybe it shouldn't do that?)

### Check-Taps
Queries your TapList and Fingers users in the list. Returns objects containing User and Content properties. Content is the full path name of any newly created archives. Use `get-content` to pull the content into your terminal

example `Get-Content (Check-Taps)[0].Content`

example `Check-Taps | % {Get-Content $_.Content}`

example `$newContent = Check-Taps; Write-Host "You have $($newContent.Count) new messages on tap."`

### Publish-PlanFile
Takes in a file path to a txt file and your Happynetbox.com credentials and posts the contents of that text file to the service. Will return an error if you provide the wrong username and password. Will create a new account if you provide a username and password that isn't currently in use, and then post the content. 

example `$content = ~\posts\newpost.txt; $creds = Get-Credential -username 'paradox'; Publish-PlanFile -path $content -credential $cred`

## Using Tap My Finger
you can dot source this file within your powershell profile to gain access to its commands (maybe one day I'll make this a module).

dot source example: `. .\tapmyfinger.ps1`