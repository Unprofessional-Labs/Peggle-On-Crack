extends Node

signal reset()
signal start_game()
signal end_game()
signal announce_checkpoint()

var INGAME = false

var PRELOADS = {
	"ScorePopupText": preload("res://Scenes/Display/ScorePopupText.tscn"),
	"PlayerBall": preload("res://Scenes/Entities/PlayerBall.tscn"),
	"PlayerBallShadow": preload("res://Scenes/Display/PlayerBallShadow.tscn")
}


var GAME_VAR

var SAVED_DATA = {
	"best_score": 10000000
}

var modifier_levels = [] # levels
var modifier_values = []
var modifier_max_level = []

enum MODIFIER {
	overdrive,
	acceleration,
	scarcity,
	absorbency,
	rush,
	damping,
	ineffectiveness,
	uncontrollability,
	bleeding,
	streak,
	obscurity,
}

# pairs of [value per level, is additive]
var modifier_value_per_level = [
	[0.25, true],
	[0.5, false],
	[0.75, false],
	[0.75, false],
	[0.5, false],
	[1, true],
	[0.5, false],
	[1.25, false],
	[2, true],
	[6, true],
	[3, true],
]

func get_modifier_multiplier():
	var sum = 1.0
	for i in modifier_levels:
		sum += i*0.1
	return sum

func update_modifier_values():
	for i in range(modifier_levels.size()):
		var modifier_level = modifier_levels[i]
		var value
		if modifier_value_per_level[i][1] == true:
			value = modifier_value_per_level[i][0] * modifier_level
		else:
			value = pow(modifier_value_per_level[i][0], modifier_level)
		
		modifier_values[i] = value

# these are array of pairs/triplets
var multipliers = [] # 0 - multiplier; 1 - time left; 2 - sprite frame
var powerups = [] # 0 - powerup; 1 - time left

func addMultiplier(multiplier:int, time:float) -> void:
	multipliers.push_back([multiplier, time])

signal triggerPowerup(name, enable)

enum POWERUP {
	super_bounce
	slow_time
	pierce
	multiball
	enlarge
	ghost
	bamboozle
}

func addPowerup(powerup:int, time:float, sprite_frame:int) -> void:
	powerups.push_back([powerup, time, sprite_frame])
	emit_signal("triggerPowerup", powerup, true)

func removePowerup(index: int) -> void:
	var powerupToBeRemoved = powerups[index][0]
	powerups.remove(index)
	emit_signal("triggerPowerup", powerupToBeRemoved, false)

func get_multiplier():
	var multiplier = 0
	for i in multipliers:
		multiplier += i[0]
	
	if multiplier == 0:
		multiplier = 1
	
	if GAME_VAR.combo >= 25:
		multiplier *= 2
	
	return multiplier

var starting_time = 30
func initialize() -> void:
	GAME_VAR = {
		"score": 0,
		"timer": starting_time,
		"combo": 0,
		"can_dash": true,
		"dash_cooldown_remaining_decimal": 0,
		"time_is_up": false,
		"game_over": false
	}

	multipliers = []


func reset() -> void:
	initialize()
	emit_signal("reset")

var random = RandomNumberGenerator.new()

func initialize_variables():
	var number_of_modifiers = MODIFIER.size()
	modifier_levels.resize(number_of_modifiers)
	modifier_levels.fill(0)
	modifier_values.resize(number_of_modifiers)
	modifier_values.fill(0)
	modifier_max_level.resize(number_of_modifiers)
	
	var best_score = SAVED_DATA["best_score"]
	var score_per_modifier = 400
	modifier_max_level.fill(int( best_score / (score_per_modifier * number_of_modifiers) ))
	
	for i in range(modifier_max_level.size()):
		if best_score % (score_per_modifier * number_of_modifiers) > (i+1)*score_per_modifier:
			modifier_max_level[i] += 1
	
	update_modifier_values()

onready var structures
func start_game():
	# Update modifiers here lol
	
	emit_signal("start_game")
	INGAME = true
	
	yield(get_tree(), "idle_frame")
	
	structures = first_node_in_group("structures")
	$BleedingTimer.start()
	if structure_invisible_interval > 0:
		structures.modulate.a = 0
		$StructuresInvisibleTimer.start()
		$StructuresInvisibleTimer.wait_time = structure_invisible_interval
	else:
		structures.modulate.a = 1
	
func end_game_func():
	GAME_VAR.game_over = true
	INGAME = false
	$BleedingTimer.stop()
	$StructuresInvisibleTimer.stop()
	
	if structure_invisible_interval > 0:
		$Tween.interpolate_property(structures, "modulate:a", 0, 1, 3, Tween.TRANS_LINEAR)
		$Tween.start()

func _ready() -> void:
	initialize_variables()
	random.randomize()
	connect("end_game", self, "end_game_func")
	
	initialize()
	
func get_world_node(node_name):
	return get_tree().get_root().get_node("World/" + node_name)

func add_world_node(instance):
	get_tree().get_root().add_child(instance)

func add_score_label(pos:Vector2, text:String, preset:String="") -> void:
	var instance = PRELOADS.ScorePopupText.instance()
	var textadd: String = text
	var time:float = 1
	
	match preset:
		"powerup":
			textadd = "[color=#8373FF]POWER[/color][color=#FF75FC]UP![/color]"
			instance.scale = Vector2(2, 2)
			instance.blinking = true
			time = 5
		"multiplier":
			textadd = "[color=#FFFF00]x" + textadd + "[/color]"
			instance.scale = Vector2(1.5, 1.5)
		"timer":
			textadd = "[color=#2EE9F0]+" + textadd + "s[/color]"
		"":
			pass
	
	instance.init(pos, textadd)
	
	get_tree().get_root().add_child(instance)

func randint_range(from, to) -> int:
	return random.randi_range(from, to)

var time_scales = {
	"player": 1.0,
	"overdrive_modifier": 1.0
}

var time_ticking_scales = {
	"slow_time_powerup": 1.0,
}

var time_peg_effectiveness_multiplier:float = 1
var powerup_peg_duration_multiplier:float = 1

var time_ticking_enabled:bool = true

func _process(delta: float) -> void:
	if INGAME:
		process_ingame(delta)
	else:
		Engine.time_scale = 1

func process_ingame(delta: float) -> void:
	# MULTIPLIER EXECUTE
	var i = 0
	while i < multipliers.size():
		multipliers[i][1] -= delta
		if multipliers[i][1] <= 0:
			multipliers.remove(i)
		else:
			i+=1

	# POWERUP EXECUTE
	i = 0
	while i < powerups.size():
		powerups[i][1] -= delta
		if powerups[i][1] <= 0:
			removePowerup(i)
		else:
			i+=1
	
	var productTimeScale:float = 1
	for j in time_scales:
		productTimeScale *= time_scales[j]
	Engine.time_scale = productTimeScale
	
	var productTimeTickingScale:float = 1
	for j in time_ticking_scales:
		productTimeTickingScale *= time_ticking_scales[j]
	
	if time_ticking_enabled:
		if GAME_VAR.timer > 0:
			GAME_VAR.timer -= delta * productTimeTickingScale
			GAME_VAR.timer = max(0, GAME_VAR.timer)
			GAME_VAR.time_is_up = false
		else:
			GAME_VAR.time_is_up = true

var minimum_combo_to_register_points = 0
func add_combo():
	GAME_VAR.combo += 1
	$ComboTimer.start()
	$DeadPointsTimer.start()

func _on_ComboTimer_timeout() -> void:
	GAME_VAR.combo = 0

func first_node_in_group(groupname):
	return get_tree().get_nodes_in_group(groupname)[0]

# modifier global functions
var bleeding_score_amount = 0
func _on_BleedingTimer_timeout() -> void:
	if time_ticking_enabled:
		GAME_VAR["score"] -= bleeding_score_amount

var structure_invisible_interval = 0
func _on_StructuresInvisibleTimer_timeout() -> void:
	$Tween.interpolate_property(structures, "modulate:a", 1, 0, 1, Tween.TRANS_LINEAR)
	$Tween.start()
