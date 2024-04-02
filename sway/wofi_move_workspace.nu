#!/usr/bin/env nu

let workspaces = swaymsg -t get_workspaces | from json | get name
let wofi_string = $workspaces | str join "\n"
let user_response = $wofi_string | wofi --dmenu --prompt "Move To Workspace"

if ($user_response == "") {
	exit
}

if ($user_response | str ends-with "!") {
	swaymsg workspace ($user_response | str trim --right --char "!")
} else {
	swaymsg move container to workspace $user_response
}

