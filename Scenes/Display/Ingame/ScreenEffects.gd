extends CanvasLayer

func _ready() -> void:
	Global.connect("end_game", self, "end_game")
	$EndscreenCover.visible = false
	$EndscreenContents.visible = false

func end_game() -> void:
	$Tween.start()
	
	$Tween.interpolate_property($Ingame, "modulate:a", 1, 0, 1, Tween.TRANS_LINEAR)
	
	yield(get_tree().create_timer(1), "timeout")
	
	$Tween.interpolate_property($EndscreenCover, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR)
	yield(get_tree(), "idle_frame")
	$EndscreenCover.visible = true
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	
	$Tween.interpolate_property($EndscreenContents, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR)
	yield(get_tree(), "idle_frame")
	$EndscreenContents.visible = true

#func _process(delta: float) -> void:
#	pass

func _on_Button_pressed() -> void:
	Global.emit_signal("switch_to_menu")
	get_tree().change_scene("res://MainTitle.tscn")
