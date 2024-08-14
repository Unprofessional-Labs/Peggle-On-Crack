extends Node2D

func _ready() -> void:
	Global.connect("end_game", self, "end")

func end():
	pass
