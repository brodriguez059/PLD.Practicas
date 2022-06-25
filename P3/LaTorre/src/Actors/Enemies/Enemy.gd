class_name Enemy
extends Actor


enum State {
	WALKING,
	CHASING,
	ATTACKING,
	DEAD
}

var _state = State.WALKING

export(bool) var is_passive = false
export (int) var aggro_radius = 50

onready var collision_shape = $CollisionShape2D
onready var floor_detector_right = $FloorDetectorRight
onready var floor_detector_left = $FloorDetectorLeft
onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var aggro_detector = $AggroRadiusDetector
onready var sprite = $Sprite
onready var attack_detector = $AttackDetector
onready var attack_timer = $AttackDetector/AttackTimer
onready var attack_sound = $AttackDetector/AttackSound
onready var attack_animation = $AttackDetector/AttackSprite/AttackAnimation
onready var death_timer = $DeathTimer

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	_velocity.x = speed.x
	aggro_detector.cast_to = Vector2(0,aggro_radius)

# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# At a glance, you can see that the physics process loop:
# 1. Calculates the move velocity.
# 2. Moves the character.
# 3. Updates the sprite direction.
# 4. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	if _state != State.DEAD:
		# If the player is seen, increase the speed
		if aggro_detector.is_colliding():
			var body = aggro_detector.get_collider()
			if body is Character:
				_velocity.x = 2 * speed.x if _velocity.x > 0 else 2 * -speed.x
				

		# If the enemy encounters a wall or an edge, the horizontal velocity is flipped.
		if not floor_detector_left.is_colliding():
			_velocity.x = speed.x
		elif not floor_detector_right.is_colliding():
			_velocity.x = -speed.x

		if is_on_wall():
			_velocity.x = -speed.x if _velocity.x > 0 else speed.x # Reset the velocity

		if attack_detector.enabled and attack_detector.is_colliding():
			var body = attack_detector.get_collider()
			attack(body)
	
		# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
		if animation_player.current_animation != "idle":
			_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

			# We flip the Sprite depending on which way the enemy is moving.
			if _velocity.x > 0:
				sprite.scale.x = 1
				attack_detector.rotation_degrees = -90
				aggro_detector.rotation_degrees = -90
			else:
				sprite.scale.x = -1
				attack_detector.rotation_degrees = 90
				aggro_detector.rotation_degrees = 90

	var animation = get_new_animation()
	if animation != null and animation != animation_player.current_animation:
		animation_player.play(animation)


func destroy():
	_state = State.DEAD
	_velocity = Vector2.ZERO


func get_new_animation():
	var animation_new = ""
	if _state == State.ATTACKING:
		animation_new = "idle"
	elif _state == State.WALKING or _state == State.CHASING:
		if _velocity.x == 0:
			animation_new = "idle"
		else:
			animation_new = "walk"
	else:
		animation_new = "destroy"
	return animation_new

func _on_AttackTimer_timeout() -> void:
	if _state != State.DEAD:
		attack_detector.enabled = true
		_state = State.WALKING
		animation_player.play("walk")

func attack(body) -> void:
	if body is Character:
		_state = State.ATTACKING
		attack_detector.enabled = false
		animation_player.play("idle")
		attack_sound.play()
		attack_animation.play("attack")
		attack_timer.start()
		body.receive_damage(self.power)


func _on_DeathTimer_timeout() -> void:
	queue_free()
