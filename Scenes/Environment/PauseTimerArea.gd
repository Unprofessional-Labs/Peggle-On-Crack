extends "res://Scenes/Environment/PlayerArea.gd"

func enter(area) -> void:
	var parent:PlayerBall = area.get_parent()
	parent.enable_dash_stalling = true
	Global.time_ticking_enabled = false
	
func exit(area) -> void:
	var parent:PlayerBall = area.get_parent()
	parent.enable_dash_stalling = false
	Global.time_ticking_enabled = true
