extends Node2D

var blinking:bool = false

func init(pos, text, time=1):
	global_position = pos
	$Timer.wait_time = time
	$Text.bbcode_text = "[center]" + str(text) + "[/center]"

func _ready() -> void:
	yield(get_tree(), "idle_frame")
	$Timer.start()
	if blinking:
		visible = false

func _process(delta: float) -> void:
	global_position.y -= delta*50
	modulate.a = $Timer.time_left / $Timer.wait_time

func _on_Timer_timeout() -> void:
	queue_free()

func _on_BlinkingTimer_timeout() -> void:
	if blinking:
		visible = !visible
