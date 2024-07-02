extends Node2D

var line_extent = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if $Raycast.is_colliding():
		$Line.points[1].x = min($Raycast.get_collision_point().distance_to(global_position), line_extent*64)
	else:
		$Line.points[1].x = line_extent*64
