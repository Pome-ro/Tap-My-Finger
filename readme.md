# 👉 Tap My Finger
Use this PS1 file in your profile to get updates from users via Finger and check on their status automatically

## Commands
There are a handful of commands in this script. 

### Finger-Someone
Pulls a users current Finger status and stores it within a folder in `~\fingered\user@name`

### Tap-Someone
Adds a user to your finger subscriptions stored in `~\fingered\subscriptions.csv`

### Check-Taps
Queries either a user or your subscriptions list and returns `true` or `false`. If the finger result is different then the last archived finger message for the user, it returns `true` otherwise it returns `false`. Returns `false` if there isn't a current finger file. 

## Using Tap My Finger
you can dot source this file within your powershell profile to gain access to its commands (maybe one day I'll make this a module)

example: `c:\path\to\pull-my-finger\tapmyfinger.ps1`

You can add `Check-Taps` your profile so it runs every time you start powershell for example. Or you can run reach command by hand if you want. 