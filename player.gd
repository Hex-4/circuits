#extends CharacterBody2D
#
#
#@export var MAX_SPEED = 1000
#@export var CHANGE = 2000
#
#
#func _physics_process(delta: float) -> void:
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	#
	#if input_direction != Vector2.ZERO:
		#velocity += input_direction * delta * CHANGE
	#else:
		#velocity -= velocity.normalized() * CHANGE * delta
		#
	#if velocity.length() > MAX_SPEED: 
		#velocity = velocity.normalized() * MAX_SPEED
		#
	#move_and_slide()

extends CharacterBody2D

@export var speed = 1200
@export var jump_speed = -1800
@export var gravity = 4000
@export_range(0.0, 1.0) var friction = 0.06
@export_range(0.0 , 1.0) var acceleration = 0.08


func _physics_process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	if dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
		velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		velocity.y = lerp(velocity.y, 0.0, friction)
	
	move_and_slide()
