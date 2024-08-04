extends Node

export var enabled = false
onready var parent = get_parent()

func _ready() -> void:
	Global.connect("announce_checkpoint", self, "change")
	change()
	
func change() -> void:
	yield(get_tree(), "idle_frame")
	if enabled:
		parent.modulate = Global.get_world_node("Structures").CURRENT_COLOR
