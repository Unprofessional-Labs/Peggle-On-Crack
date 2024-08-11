extends RichTextLabel

func _process(delta: float) -> void:
	var mul = Global.get_modifier_multiplier()
	bbcode_text = "Modifier bonus: "
	bbcode_text += "" if mul == 1 else "[color=#FFFF00]"
	bbcode_text += str(mul) + "x"
