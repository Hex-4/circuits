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
@export var separation_dist = 300
@onready var life = $"HUD/Life"
@export var scrap_count: Label
var dir: Vector2
var positive: CharacterBody2D
var negative: CharacterBody2D
var shorted = false
var immunity = 5
var active_pickup = null
var held_pickup = null



func _physics_process(delta):
	var target_zoom = Vector2(0.5, 0.5) if positive and negative else Vector2(0.3, 0.3)
	$Camera.zoom = $Camera.zoom.move_toward(target_zoom, 0.3 * delta)

	
	$HUD.look_at(get_global_mouse_position())
	
	if immunity > 0:
		immunity -= delta


	dir = Input.get_vector("left", "right", "up", "down")
	if dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
		velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		velocity.y = lerp(velocity.y, 0.0, friction)
		
	if dir != Vector2.ZERO:
		var tween = get_tree().create_tween()
		var weird_dir = Vector2(dir.x, -dir.y)
		if rotation != weird_dir.angle_to(Vector2.DOWN):
			tween.tween_property(self, "rotation", weird_dir.angle_to(Vector2.DOWN), 0.4)
			
	if Input.is_action_just_pressed("b"):
		use_pickup()
	
	move_and_slide()
	
func short():
	immunity = 3
	var t = get_tree().create_tween()
	t.tween_property($ColorRect, "color", Color($ColorRect.color, 1), 0.1)
	t.parallel().tween_property($Sprite2D/ColorRect, "color", Color($Sprite2D/ColorRect.color, 1), 0.04)
	t.tween_callback(life.decrease)
	t.tween_property($ColorRect, "color", Color($ColorRect.color, 0), 0.2)
	t.parallel().tween_interval(1)
	t.tween_property($Sprite2D/ColorRect, "color", Color($Sprite2D/ColorRect.color, 0), 1.8)
	

func pickup(type):
	held_pickup = type

	match type:
		"speed":
			(%PickupUI as Sprite2D).texture.region.position.y = 0
			var t = create_tween()
			t.set_ease(Tween.EASE_IN)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property(%PickupUI, "scale", Vector2(1, 1), 0.5)
		"shoot":
			(%PickupUI as Sprite2D).texture.region.position.y = 64 * 1
			var t = create_tween()
			t.set_ease(Tween.EASE_IN)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property(%PickupUI, "scale", Vector2(1, 1), 0.5)
		"life":
			(%PickupUI as Sprite2D).texture.region.position.y = 64 * 2
			var t = create_tween()
			t.set_ease(Tween.EASE_IN)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property(%PickupUI, "scale", Vector2(1, 1), 0.5)
		
func use_pickup():
	$PickupTimer.start(8)
	owner.difficulty += 5
	active_pickup = held_pickup
	held_pickup = null
	match active_pickup:
		"speed":
			speed += 600
			var t = create_tween()
			t.set_ease(Tween.EASE_IN)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property(%PickupUI, "scale", Vector2(0, 0), 0.5)
		"shoot":
			$HUD/Blaster/Timer.wait_time = 0.05
			var t = create_tween()
			t.set_ease(Tween.EASE_IN)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property(%PickupUI, "scale", Vector2(0, 0), 0.5)
		"life":
			if $HUD/Life.life < 3:
				print("relived")
				$HUD/Life.increase()
			else:
				scrap_count.text = str(int(scrap_count.text) + 30)
			var t = create_tween()
			t.set_ease(Tween.EASE_IN)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property(%PickupUI, "scale", Vector2(0, 0), 0.5)
			active_pickup = null

func _on_pickup_timer_timeout() -> void:
	match active_pickup:
		"speed":
			speed -= 600
			active_pickup = null
		"shoot":
			$HUD/Blaster/Timer.wait_time = 0.1
			active_pickup = null
	
