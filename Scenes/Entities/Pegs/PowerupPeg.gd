extends Peg

var powerup = Global.POWERUP.bamboozle
export var time = 10

func addlabel() -> void:
	Global.add_score_label(global_position, "text doesn't really matter here as it is overridden", "powerup")

func trigger(body) -> void:
	pass
	
func endtrigger(body) -> void:
	Global.addPowerup(powerup, time, $Sprite/Sprite.frame)
