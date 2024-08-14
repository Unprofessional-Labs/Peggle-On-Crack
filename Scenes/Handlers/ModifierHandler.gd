extends Node

# array of triplets
var modifier_details = [
	["Overdrive", "The game is ??? faster", "x"],
	["Acceleration", "The starting timer is ??? as long", "x"],
	["Scarcity", "Time pegs give ??? as much", "x"],
	["Absorbency", "The ball is ??? as bouncy", "x"],
	["Rush", "Dash adjustment duration is ??? as long", "x"],
	["Damping", "Motion damping is now ???", ""],
	["Ineffectiveness", "Powerup duration is ??? as long", "x"],
	["Uncontrollability", "Dash cooldown is ??? as long", "x"],
	["Bleeding", "Deduces ??? every second", " points"],
	["Streak", "Points are only rewarded at ??? and above", " combo"],
	["Obscurity", "The game is only visible every ???", " seconds"],
]

func _ready() -> void:
	Global.connect("start_game", self, "update_modifier_effects")

func update_modifier_effects():
	yield(get_tree(), "idle_frame")
	for i in range(Global.MODIFIER.size()):
		var value = Global.modifier_values[i]
		
		match i:
			Global.MODIFIER.overdrive:
				Global.time_scales["overdrive_modifier"] = 1+value
				
			Global.MODIFIER.acceleration:
				Global.GAME_VAR["timer"] = Global.starting_time * value
			
			Global.MODIFIER.scarcity:
				Global.time_peg_effectiveness_multiplier = value
				
			Global.MODIFIER.absorbency:
				Global.first_node_in_group("player").bounce_scales["absorbency_modifer"] = value
				
			Global.MODIFIER.rush:
				Global.first_node_in_group("player").time_to_adjust_dash_multiplier = value
				Global.first_node_in_group("player").get_node("DashHoldTimer").wait_time = 0.05 * value
				
			Global.MODIFIER.damping:
				Global.first_node_in_group("player").damping_addends["damping_modifier"] = value
				
			Global.MODIFIER.ineffectiveness:
				Global.powerup_peg_duration_multiplier = value
				
			Global.MODIFIER.uncontrollability:
				Global.first_node_in_group("player").dash_cooldown_scales["uncontrollability_modifier"] = value
				
			Global.MODIFIER.bleeding:
				Global.bleeding_score_amount = value
				
			Global.MODIFIER.streak:
				Global.minimum_combo_to_register_points = value
				
			Global.MODIFIER.obscurity:
				Global.structure_invisible_interval = value

func _process(delta: float) -> void:
	pass
