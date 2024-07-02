# https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html
extends Camera2D

export var decay: float = 1  # How quickly the shaking stops [0, 1].
export var max_offset: Vector2 = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll: float = 0.5 # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.

var trauma: float = 0.0  # Current shake strength.
var trauma_power: float = 2  # Trauma exponent. Use [2, 3].

onready var noise = OpenSimplexNoise.new()
var noise_y: int = 0

func _ready():
	Global.connect("end_game", self, "zoom_out_end")
	
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func zoom_out_end():
	var tween = get_node("../Tween")
	tween.interpolate_property(self, "zoom", Vector2(0.5, 0.5), Vector2(1, 1), 3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func set_trauma(amount):
	trauma = max(trauma, amount)
	
func _process(delta):
	if target:
		global_position = get_node(target).global_position
	
	if trauma:
		trauma = max(trauma - decay * delta * (1/Engine.time_scale), 0)
		shake()
		
func shake():
	var amount: float = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

# CONNECT THIS SIGNAL IN ROOT NODE
func _on_PlayerBall_body_entered(body: Node) -> void:
	set_trauma(0.25)
