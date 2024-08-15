extends Node2D

func _ready() -> void:
	Global.connect("end_game", self, "end")

func end():
	# Stats
	$Text.bbcode_text = "GAME STATISTICS:\n\n"
	$Text.bbcode_text += "Total time: " + Global.bb_wrap_color(str(round(Global.STATS["total_time"])) + "s", "FFFF00") + "\n"
	$Text.bbcode_text += "Distance: " + Global.bb_wrap_color(str(round(Global.STATS["distance"])) + "m", "FFFF00") + "\n"
	$Text.bbcode_text += "Pegs destroyed: " + Global.bb_wrap_color(str(Global.STATS["pegs_destroyed"]) + " pegs", "FFFF00") + "\n"
	$Text.bbcode_text += "Peak multiplier: " + Global.bb_wrap_color(str(Global.STATS["peak_multiplier"]) + "x multiplier", "FFFF00") + "\n"
	$Text.bbcode_text += "Peak combo: " + Global.bb_wrap_color(str(Global.STATS["peak_combo"]) + " combo", "FFFF00") + "\n"
	$Text.bbcode_text += "Peak ball count: " + Global.bb_wrap_color(str(Global.STATS["peak_ball_count"]) + " balls", "FFFF00") + "\n"
	$Text.bbcode_text += "Peak destruction density: " + Global.bb_wrap_color(str(Global.STATS["peak_destruction_density_per_second"]) + " pegs destroyed per second", "FFFF00") + "\n"

	# Modifiers
	var multiplier = Global.get_modifier_multiplier()
	print(multiplier)
	$Text2.bbcode_text = "MODIFIER DETAILS: \n\n"
	if multiplier == 1:
		$Text2.bbcode_text += "[No modifiers enabled]"
	else:
		$Text2.bbcode_text += "Multiplier: " + Global.bb_wrap_color(str(multiplier) + "x", "FFFF00") + "\n"
		
		for index in range(Global.MODIFIER.size()):
			if Global.modifier_levels[index] == 0:
				continue
			
			var details = Global.get_node("ModifierHandler").modifier_details[index]
			var rawlevel = Global.modifier_levels[index]
			var level = str(rawlevel)
			var value = str(Global.modifier_values[index]) + details[2]
			
			if rawlevel != 0:
				level = "[color=#FFFF00]" + level + "[/color]"
				value = "[color=#FFFF00]" + value + "[/color]"
				
			var desc = details[1].replace("???", value)
			
			$Text2.bbcode_text += "\n- "
			$Text2.bbcode_text += details[0] + " "
			$Text2.bbcode_text += level
			$Text2.bbcode_text += ": " + desc
