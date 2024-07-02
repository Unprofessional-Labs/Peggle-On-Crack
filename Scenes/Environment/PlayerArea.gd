extends Area2D

export var only_once_enter:bool = false
var activated_once_enter:bool = false
export var only_once_exit:bool = false
var activated_once_exit:bool = false

# Extend script and change enter exit functions
func enter(area) -> void:
	pass

func exit(area) -> void:
	pass

func _on_PlayerArea_area_entered(area: Area2D) -> void:
	if only_once_enter && activated_once_enter:
		return
		
	activated_once_enter = true
	enter(area)

func _on_PlayerArea_area_exited(area: Area2D) -> void:
	if only_once_exit && activated_once_exit:
		return
		
	activated_once_exit = true
	exit(area)
