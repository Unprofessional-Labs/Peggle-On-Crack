extends Peg

export var extraTime = 1 # seconds

func addlabel() -> void:
	var final = extraTime * Global.time_peg_effectiveness_multiplier
	Global.add_score_label(global_position, str(final), "timer")
	
func endtrigger(body) -> void:
	var final = extraTime * Global.time_peg_effectiveness_multiplier
	Global.GAME_VAR.timer += final
