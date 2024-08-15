extends Node

var paused = false

func _ready() -> void:
	update()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle()

func toggle():
	paused = !paused
	update()

func update():
	get_tree().paused = paused
	get_parent().visible = paused

func _on_Button_pressed() -> void:
	toggle()
	Global.STATS["total_time"] -= Global.GAME_VAR["timer"]
	Global.GAME_VAR["timer"] = 0
