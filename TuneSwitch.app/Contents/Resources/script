on str_replace(tofind, toreplace, TheString)
	set ditd to text item delimiters
	set text item delimiters to tofind
	set textItems to text items of TheString
	set text item delimiters to toreplace
	if (class of TheString is string) then
		set res to textItems as string
	else -- if (class of TheString is Unicode text) then
		set res to textItems as Unicode text
	end if
	set text item delimiters to ditd
	return res
end str_replace

on appisrunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appisrunning


if appisrunning("Usable Keychain Scripting") is false then
	set AppPath to POSIX path of (path to me)
	set AppPath to str_replace("/script", "/Usable Keychain Scripting.app", AppPath)
	do shell script ("open " & quoted form of AppPath)
end if

set ScriptPath to POSIX path of (path to me)
set ScriptPath to str_replace("/script", "/TuneSwitch.applescript", ScriptPath)

run script ScriptPath

if appisrunning("Usable Keychain Scripting") then
	tell application "Usable Keychain Scripting"
		quit
	end tell
end if