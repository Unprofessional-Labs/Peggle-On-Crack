extends Ball
class_name PlayerBall

var DASH_FORCE:int = 500
var ended:bool = false
var gravity_scale_multiplier:int = 1

var enable_dash_stalling:bool = false
var is_instance:bool = false

func _ready() -> void:
	pass

func init(pos) -> void:
	global_position = pos
	is_instance = true

var charging_dash: bool = false

func start_dash():
	if is_instance:
		return
		
	charging_dash = true
	Global.time_scales.player = 0.05
	
	$Tween.remove($TrajectoryLine, "line_extent")
	$Tween.interpolate_property($TrajectoryLine, "line_extent", $TrajectoryLine.line_extent, 1, 0.075, Tween.TRANS_SINE)
	$Tween.start()
	
	if !enable_dash_stalling:
		yield(get_tree().create_timer(2*0.05), "timeout")
		
		if charging_dash:
			$Tween.remove($TrajectoryLine, "line_extent")
			$Tween.interpolate_property($TrajectoryLine, "line_extent", $TrajectoryLine.line_extent, 0, $DashHoldTimer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN)
			$Tween.start()
			
			$DashHoldTimer.start()

func get_speed() -> float:
	return linear_velocity.length()

func dash() -> void:
	if is_instance:
		return
		
	$DashHoldTimer.stop()
	
	charging_dash = false
	$Tween.remove($TrajectoryLine, "line_extent")
	$Tween.interpolate_property($TrajectoryLine, "line_extent", $TrajectoryLine.line_extent, 0, 0.25, Tween.TRANS_SINE)
	$Tween.start()
	
	Global.time_scales.player = 1
	linear_velocity = Vector2.ZERO
	apply_central_impulse(global_position.direction_to(get_global_mouse_position()) * -DASH_FORCE)
	
	$DashTimer.start()
	Global.GAME_VAR.can_dash = false
	
	$DashTrailTimer.start()
	activate_trail()

func activate_trail():
	while !$DashTrailTimer.is_stopped():
		var instance = Global.PRELOADS.PlayerBallShadow.instance()
		instance.init(global_position)
		Global.add_world_node(instance)
		yield(get_tree().create_timer(0.05), "timeout")

func dash_update_process() -> void:
	if is_instance:
		return
		
	Global.GAME_VAR.dash_cooldown_remaining_decimal = $DashTimer.time_left / $DashTimer.wait_time
	
	if Input.is_action_pressed("launch") && $DashTimer.is_stopped() && !charging_dash:
		start_dash()

	if Input.is_action_just_released("launch") && charging_dash:
		dash()
	
	if $DashTimer.is_stopped():
		$TrajectoryLine.rotation = -rotation + global_position.angle_to_point(get_global_mouse_position())

func end(enable:bool) -> void:
	if enable:
		if charging_dash:
			dash()
			
		gravity_scale = 0
		linear_damp = 1
		if abs(linear_velocity.x) < 5 && abs(linear_velocity.y) < 5:
			linear_velocity = Vector2.ZERO
			
			if !ended && !is_instance:
				Global.emit_signal("end_game")
			
			ended = true
	else:
		gravity_scale = 10 * gravity_scale_multiplier
		linear_damp = 0
			

func anti_softlock() -> void:
	if abs(global_position.x) > 700:
		global_position.x = 0
	
	var peak_y = Global.get_world_node("Structures").peak_y
	if peak_y > global_position.y:
		global_position.y = peak_y + 100

func _physics_process(delta: float) -> void:
	$Sprite.global_rotation = 0
	$ComboParticles.emitting = Global.GAME_VAR.combo >= 25
	
	anti_softlock()
	
	if Global.GAME_VAR.time_is_up:
		end(true)
		return
	else:
		end(false)
	
	dash_update_process()

#func _process(delta: float) -> void:
#	pass

func _on_DashTimer_timeout() -> void:
	Global.GAME_VAR.can_dash = true

func _on_DashHoldTimer_timeout() -> void:
	dash()
