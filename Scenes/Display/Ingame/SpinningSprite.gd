extends Sprite

export var roundsPerSecond:float = 1
export var randomDirection:bool = true

var direction:int = 1

func _ready() -> void:
	if Global.randint_range(0, 1) == 0:
		direction = -1

func _process(delta: float) -> void:
	rotation_degrees += 360 * delta * roundsPerSecond * direction
