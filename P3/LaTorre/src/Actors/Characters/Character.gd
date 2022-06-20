class_name Character
extends Actor

# Signals

# warning-ignore:unused_signal
signal player_died()
# warning-ignore:unused_signal
signal health_changed(value)
# warning-ignore:unused_signal
signal mana_changed(value)
# warning-ignore:unused_signal
signal coin_picked(value)

# Entity constants
const FLOOR_DETECT_DISTANCE = 20.0

# Entity definition
# Others
export(int) var view_radius = 0
export(int) var coins = 0
export(String) var player_code = ""

# Node variables
onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var attack_timer = $AttackAnimation
onready var sprite = $Sprite
onready var sound_jump = $Jump
onready var weapon = sprite.get_node(@"Weapon") # @ -> create/indicate NodePath

func _ready():
	# Static types are necessary here to avoid warnings.
	var camera: Camera2D = $Camera


# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):

	# Play jump sound
	if Input.is_action_just_pressed("jump" + player_code) and is_on_floor():
		sound_jump.play()

	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump" + player_code) and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO # Disable the snap in order to jump
	if direction.y == 0.0: # Enable the snap in case there is a slope
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, # Linear velocity
		snap_vector, # Snap vector (to jump if disabled, to slide otherwise)
		FLOOR_NORMAL, # Up vector
		not is_on_platform, # Stop on slope (This will keep stability on moveable platforms)
		4, # max_slides ()
		0.9, # floor_max_angle (Max angle of slope to be able to snap to it)
		false # infinite_inertia ()
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make the character face left or right depending on the direction you move.
	if direction.x != 0:
		if direction.x > 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1

	# We use the sprite's scale to store the character's look direction which allows us to attack forward
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.
	var is_shooting = false
	if Input.is_action_just_pressed("attack" + player_code):
		is_shooting = weapon.shoot(sprite.scale.x)

	var animation = get_new_animation(is_shooting)
	if animation != animation_player.current_animation and attack_timer.is_stopped():
		if is_shooting:
			attack_timer.start()
		animation_player.play(animation)


# Auxiliary functions

func get_direction():
	return Vector2(
		Input.get_action_strength("move_right" + player_code) - Input.get_action_strength("move_left" + player_code), # x-axis
		-1 if is_on_floor() and Input.is_action_just_pressed("jump" + player_code) else 0 # y-axis
	)

# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity

func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting: # TODO Revisar aquí
		animation_new += "_weapon"
	return animation_new

# Signal emitters

func die() -> void:
	health = 0.0
	$AnimationPlayer.play("death")
	emit_signal("player_died")

func collect_coin():
	coins += 1
	emit_signal("coin_picked", coins)
