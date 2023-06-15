#MaxThreadsPerHotkey 3
#SingleInstance, force

^z::
Toggle := !Toggle
Loop
{
	If (!Toggle)
		Break
	Click
	Sleep 10 ; Make this number higher for slower clicks, lower for faster.
}