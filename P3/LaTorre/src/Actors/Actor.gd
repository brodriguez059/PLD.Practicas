class_name Actor
extends KinematicBody2D

# Both the Player and Enemy inherit this scene as they have shared behaviours
# such as speed and are affected by gravity.

# Entity constants
const FLOOR_NORMAL = Vector2.UP
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

# Entity definition
# Static on runtime
export(float, 0, 100) var max_health = 100.0
export(float, 0, 100) var max_mana = 100.0
export(Vector2) var speed = Vector2(150.0, 400.0) # This is max movement speed
export(float, 0, 100) var max_defense = 10.0
export(float, 0, 100) var max_power = 10.0

# Dinamic on runtime
var health : float = max_health
var mana : float = max_mana
var _velocity = Vector2.ZERO # This is movement speed
var defense : float = max_defense
var power : float = max_power

# Others
export(float) var attack_speed = 1.0

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	_velocity.y += gravity * delta
