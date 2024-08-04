extends Node

signal reset()
signal end_game()
signal announce_checkpoint()

var PRELOADS = {
	"ScorePopupText": preload("res://Scenes/Display/ScorePopupText.tscn"),
	"PlayerBall": preload("res://Scenes/Entities/PlayerBall.tscn"),
	"PlayerBallShadow": preload("res://Scenes/Display/PlayerBallShadow.tscn")
}

var GAME_VAR

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
	var multiplier = 1
	for i in multipliers:
		multiplier *= i[0]
	return multiplier

func initialize() -> void:
	GAME_VAR = {
		"score": 0,
		"timer": 90,
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

func _ready() -> void:
	random.randomize()
	initialize()
	
	connect("end_game", self, "end_game_func")

func end_game_func():
	GAME_VAR.game_over = true
	
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
}

var time_ticking_multiplier:float = 1
var time_ticking_enabled:bool = true

func _process(delta: float) -> void:
	if time_ticking_enabled:
		if GAME_VAR.timer > 0:
			GAME_VAR.timer -= delta * time_ticking_multiplier
			GAME_VAR.timer = max(0, GAME_VAR.timer)
			GAME_VAR.time_is_up = false
		else:
			GAME_VAR.time_is_up = true
	
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

func add_combo():
	GAME_VAR.combo += 1
	$ComboTimer.start()

func _on_ComboTimer_timeout() -> void:
	GAME_VAR.combo = 0
