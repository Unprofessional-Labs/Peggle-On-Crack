extends Peg

export var FORCE = 600

func trigger(body) -> void:
	body.apply_central_impulse(global_position.direction_to(body.global_position) * FORCE)
	
func endtrigger(body) -> void:
	pass
