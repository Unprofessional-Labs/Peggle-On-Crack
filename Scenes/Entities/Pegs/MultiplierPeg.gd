extends Peg

export var multiplier:int = 2
export var time:int = 5 # seconds

func addlabel() -> void:
	Global.add_score_label(global_position, str(multiplier), "multiplier")
	
func endtrigger(body) -> void:
	Global.addMultiplier(multiplier, time)
