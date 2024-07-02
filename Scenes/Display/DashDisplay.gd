extends Node2D

func _ready() -> void:
	$ReferenceRect.border_color = Color("#ffffff")
	$TextureProgress.visible = !Global.GAME_VAR.can_dash

func _process(delta: float) -> void:
	if Global.GAME_VAR.time_is_up:
		$TextureProgress.value = 1
		$TextureProgress.visible = true
		$ReferenceRect.border_color = Color("#58ffffff")
	else:
		$TextureProgress.value = Global.GAME_VAR.dash_cooldown_remaining_decimal
		$TextureProgress.visible = !Global.GAME_VAR.can_dash
		$ReferenceRect.border_color = Color("#ffffff") if Global.GAME_VAR.can_dash else Color("#58ffffff")
