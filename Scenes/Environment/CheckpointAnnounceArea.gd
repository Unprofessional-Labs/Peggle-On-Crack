extends "res://Scenes/Environment/PlayerArea.gd"

func enter(area) -> void:
	Global.emit_signal("announce_checkpoint")
