extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BestScoreText.bbcode_text = "[right]Best: " + str(Global.SAVED_DATA.best_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_Button_pressed() -> void:
	Global.initialize()
	Global.start_game()
	get_tree().change_scene("res://World.tscn")
