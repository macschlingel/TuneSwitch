on appisrunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appisrunning


on createEntry()
	--Query user for username and password
	tell application "System Events"
		activate
		set theAccount to text returned of (display dialog "Enter iTS account name " with title "Create new Keychain entry" default answer "")
		set thePass to text returned of (display dialog "Enter iTS password for account " & theAccount & " name " with title "Create new Keychain entry" default answer "" with hidden answer)
	end tell
	try
		--insert new entry into keychain
		tell application "Keychain Scripting"
			make new Internet key with properties {name:"iTunes: " & theAccount, account:theAccount, password:thePass}
		end tell
		tell application "System Events"
			activate
			display dialog "Record: 'iTunes: " & theAccount & "' was successfully created!" buttons {"OK"} default button 1
		end tell
		--Restart the main Routine
		StartRoutine()
	on error errmsg
		tell application "System Events"
			activate
			display dialog errmsg
		end tell
		if appisrunning("Usable Keychain Scripting") then
			tell application "Usable Keychain Scripting"
				quit
			end tell
		end if
	end try
end createEntry

on StartRoutine()
	--get all keychain entries that start with "iTunes:"
	tell application "Usable Keychain Scripting" to tell current keychain
		activate
		set AccountList to name of every keychain item whose name starts with "iTunes:"
	end tell
	if (count of AccountList) is less than 1 then
		--create new keychain entry
		createEntry()
	else
		--select a keychain entry
		tell application "System Events"
			activate
			set theName to choose from list AccountList with prompt "Choose iTS account:" cancel button name "Create new keychain entry"
		end tell
		if theName = false then
			--create new keychain entry
			createEntry()
		else
			--start logging into different account
			try
				--Get Login credentials from keychain
				tell application "Usable Keychain Scripting" to tell current keychain
					set theAccount to account of first internet password whose name is theName
					set thePassword to password of first internet password whose name is theName
				end tell
				
				tell application "System Events"
					tell process "iTunes"
						set frontmost to true
						--Singning out and in (won't fail if already signed out)
						repeat 2 times
							click menu item 14 of menu 1 of menu bar item 7 of menu bar 1
						end repeat
						delay 0.25
						repeat with theLetter in theAccount
							keystroke theLetter
							delay 0.01
						end repeat
						keystroke tab
						repeat with theLetter in thePassword
							keystroke theLetter
							delay 0.01
						end repeat
						keystroke return
						delay 3
						keystroke return
					end tell
				end tell
			on error errmsg
				tell application "System Events"
					activate
					display dialog errmsg
				end tell
				if appisrunning("Usable Keychain Scripting") then
					tell application "Usable Keychain Scripting"
						quit
					end tell
				end if
			end try
		end if
	end if
end StartRoutine

StartRoutine()
if appisrunning("Usable Keychain Scripting") then
	tell application "Usable Keychain Scripting"
		quit
	end tell
end if
