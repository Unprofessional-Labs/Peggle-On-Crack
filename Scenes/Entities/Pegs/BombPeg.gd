extends Peg

export var FORCE = 500

var bodiesInRangeOfExplosion = []

func addlabel() -> void:
	pass

func trigger(body) -> void:
	pass

func detonate_effect(pegBody) -> void:
	pegBody.dmg(null)

func endtrigger(body) -> void:
	if body != null:
		body.apply_central_impulse(global_position.direction_to(body.global_position) * FORCE)
		
	for i in bodiesInRangeOfExplosion:
		if i != self:
			detonate_effect(i)

func _on_ExplosionArea_area_entered(area: Area2D) -> void:
	bodiesInRangeOfExplosion.push_back(area.get_parent())

func _on_ExplosionArea_area_exited(area: Area2D) -> void:
	bodiesInRangeOfExplosion.erase(area.get_parent())
