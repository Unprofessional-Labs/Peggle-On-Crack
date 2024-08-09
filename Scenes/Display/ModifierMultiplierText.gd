extends RichTextLabel

func _process(delta: float) -> void:
	bbcode_text = "Modifier bonus: " + str(Global.get_modifier_multiplier()) + "x"
