extends Control

func _ready() -> void:
	$ModifierPopupPanel.visible = false

func _on_ModifierGridContainer_modifier_mouse_enter(index) -> void:
	$ModifierPopupPanel.update_text(index)
	$ModifierPopupPanel.visible = true

func _on_ModifierGridContainer_modifier_mouse_exit() -> void:
	$ModifierPopupPanel.visible = false
