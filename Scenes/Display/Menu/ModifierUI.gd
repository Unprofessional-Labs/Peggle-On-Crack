extends Control

func _ready() -> void:
	$ModifierPopupPanel.visible = false
	if Global.SAVED_DATA.best_score < Global.score_per_modifier:
		$ModifierMultiplierText.visible = false

func _on_ModifierGridContainer_modifier_mouse_enter(index) -> void:
	$ModifierPopupPanel.update_text(index)
	$ModifierPopupPanel.visible = true

func _on_ModifierGridContainer_modifier_mouse_exit() -> void:
	$ModifierPopupPanel.visible = false
