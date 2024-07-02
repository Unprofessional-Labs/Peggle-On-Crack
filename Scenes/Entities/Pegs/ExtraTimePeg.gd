extends Peg

export var extraTime = 1 # seconds

func addlabel() -> void:
	Global.add_score_label(global_position, str(extraTime), "timer")
	
func endtrigger(body) -> void:
	Global.GAME_VAR.timer += extraTime
