extends Node2D

func _ready() -> void:
	Global.connect("end_game", self, "end")

func end():
	$Text.visible = Global.is_personal_best

func _process(delta: float) -> void:
	pass
