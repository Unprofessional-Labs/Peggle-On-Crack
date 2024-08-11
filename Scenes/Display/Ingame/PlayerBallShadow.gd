extends Sprite

func _ready() -> void:
	pass # Replace with function body.

func init(pos: Vector2) -> void:
	global_position = pos

func _process(delta: float) -> void:
	modulate.a = $Timer.time_left / $Timer.wait_time * 0.5

func _on_Timer_timeout() -> void:
	queue_free()
