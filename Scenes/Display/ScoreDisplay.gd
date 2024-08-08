extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Text.bbcode_text = " " + str(Global.GAME_VAR.score)
	
	if Global.multipliers.size() > 0:
		var sorted = Global.multipliers
		sorted.sort()
		sorted.invert()
		$Text2.bbcode_text = " [color=#FFFF00]x" + str(Global.get_multiplier()) + "[/color]"
	else:
		$Text2.bbcode_text = ""
	
	var combo = Global.GAME_VAR.combo
	if combo >= 25:
		$Text3.bbcode_text = " [color=#03fcec]" + str(combo) + " combo! (2x multiplier)[/color]"
	elif combo > 0:
		$Text3.bbcode_text = " [color=#03fcec]" + str(combo) + " combo![/color]"
	else:
		$Text3.bbcode_text = ""
		
	var comboTimer = Global.get_node("ComboTimer")
	$Text3.modulate.a = clamp(comboTimer.time_left / comboTimer.wait_time * 2, 0, 1)
