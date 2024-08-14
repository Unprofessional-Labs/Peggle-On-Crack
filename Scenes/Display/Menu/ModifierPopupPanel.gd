extends ColorRect

func update_text(index):
	$Sprite.frame = index
	
	var details = Global.get_node("ModifierHandler").modifier_details[index]
	var rawlevel = Global.modifier_levels[index]
	var level = str(rawlevel) + "/" + str(Global.modifier_max_level[index])
	var value = str(Global.modifier_values[index]) + details[2]
	
	if rawlevel != 0:
		level = "[color=#FFFF00]" + level + "[/color]"
		value = "[color=#FFFF00]" + value + "[/color]"
		
	var desc = details[1].replace("???", value)
	
	$Text.bbcode_text = details[0] + " "
	$Text.bbcode_text += level
	$Text.bbcode_text += "\n>>> " + desc
