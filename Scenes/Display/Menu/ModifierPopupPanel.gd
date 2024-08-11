extends ColorRect

# array of triplets
var modifier_details = [
	["Overdrive", "The game runs at ??? speed", "x"],
	["Acceleration", "The starting timer is ??? as long", "x"],
	["Scarcity", "Time pegs give ??? as much", "x"],
	["Absorbency", "The ball is ??? as bouncy", "x"],
	["Rush", "Dash adjustment duration is ??? as long", "x"],
	["Damping", "Motion damping is now ???", ""],
	["Ineffectiveness", "Powerup duration is ??? as long", "x"],
	["Uncontrollability", "Dash cooldown is ??? as long", "x"],
	["Bleeding", "Deduces ??? every second", " points"],
	["Streak", "Points are only rewarded at ??? and above", " combo"],
	["Obscurity", "The game is only visible every ???", " seconds"],
]

func update_text(index):
	$Sprite.frame = index
	
	var details = modifier_details[index]
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
