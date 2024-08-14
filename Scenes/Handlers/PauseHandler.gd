extends Node

var paused = false

func _ready() -> void:
	update()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		update()

func update():
	get_tree().paused = paused
	get_parent().visible = paused
