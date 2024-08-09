extends Node

func _ready() -> void:
	Global.connect("start_game", self, "update_modifier_effects")

func update_modifier_effects():
	yield(get_tree(), "idle_frame")
	for i in range(Global.MODIFIER.size()):
		var value = Global.modifier_values[i]
		
		match i:
			Global.MODIFIER.overdrive:
				Global.time_scales["overdrive_modifier"] = value
				
			Global.MODIFIER.acceleration:
				Global.GAME_VAR["timer"] = 90 * value
			
			Global.MODIFIER.scarcity:
				Global.time_peg_effectiveness_multiplier = value
				
			Global.MODIFIER.absorbency:
				Global.first_node_in_group("player").bounce_scales["absorbency_modifer"] = value
				
			Global.MODIFIER.rush:
				Global.first_node_in_group("player").time_to_adjust_dash_multiplier = value
				Global.first_node_in_group("player").get_node("DashHoldTimer").wait_time = 0.05 * value

func _process(delta: float) -> void:
	pass
