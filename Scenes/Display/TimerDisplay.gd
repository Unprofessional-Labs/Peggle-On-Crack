extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var timer = Global.GAME_VAR.timer
	var digit_places = 0
	
	if timer < 10:
		digit_places = 2
	elif timer < 100:
		digit_places = 1
	
	$Text.bbcode_text = "[center]" + ("%." + str(digit_places) + "f") % (timer) + "[/center]"
