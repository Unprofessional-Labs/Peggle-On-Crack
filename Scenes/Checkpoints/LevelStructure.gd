extends Node2D

func init(ypos: float) -> void:
	global_position = Vector2(0, ypos)

func get_global_y_top() -> float:
	return global_position.y

func get_global_y_bottom() -> float:
	return global_position.y + $ReferenceRect.rect_size.y

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
