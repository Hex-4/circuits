extends CharacterBody2D

@export var speed = 400
@export var radius = 601
@export_range(0.0, 1.0) var friction = 0.06
@export_range(0.0 , 1.0) var acceleration = 0.08
@export var separation_dist = 600
@export var hits = 1
@export var scraps = 2
var active = true

var camera: Camera2D

@onready var player
var connected = false:
	get:
		return connected
	set(value):
		if value == false and connected == true: # disconnect
			player.positive = null
			$"../DisconnectAudio".play()
		elif value == true and connected == false: # connect
			player.positive = self
			$"../ConnectAudio".play()
		connected = value
		
		
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	
func separate():
	var separation_force = Vector2.ZERO
		
	for e in $"../..".enemies:
		if e:
			if e == self:
				continue
			var dist = position.distance_to(e.position)
			if dist <= separation_dist:
				separation_force += (-position.direction_to(e.position)) * (1 - dist / separation_dist)
			
		
	return separation_force

func _physics_process(delta):
	# separation logic
	if !player:
		player = get_node("../../Player")
	if player:
		
		var dir = position.direction_to(player.position)
		
		var separation_force
		if $VisibleOnScreenNotifier2D.is_on_screen():
			separation_force = separate()
		else:
			separation_force = Vector2.ZERO
		dir += separation_force * 250
		dir = dir.normalized()
		if position.distance_to(player.position) <= radius or player.positive:
			velocity.x = lerp(velocity.x, 0.0, friction)
			velocity.y = lerp(velocity.y, 0.0, friction)
		else:
			velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
			velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
		
		move_and_slide()
	
func _process(delta: float) -> void:
	if player:
		camera = player.get_node("Camera")
		$Line2D.points = [$Line2D.to_local(position), $Line2D.to_local(player.position)]
		if position.distance_to(player.position) <= radius and not player.positive:
			connected = true
			$Line2D.visible = true
		if position.distance_to(player.position) > radius:
			connected = false
			$Line2D.visible = false
			
		if player.positive and player.negative and connected and player.negative.scale != Vector2.ZERO:
			$ShortLine.points = [$Line2D.to_local(position), $Line2D.to_local(player.negative.position)]
			if player.immunity <= 0 and $Timer.is_stopped():
				$Timer.start()
		else:
			$ShortLine.clear_points()
			
			
func damage():
	hits -= 1
	if !player:
		player = get_node("../../Player")
	player.negative = null
	
	var t = get_tree().create_tween()
	if randf_range(0, 1) < $"../..".spawn_chance:
		$"../..".spawn()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_EXPO)
	t.tween_property($"Sprite2D/ColorRect", "color", Color($Sprite2D/ColorRect.color, 1), 0.05)
	if hits > 0:
		t.tween_property($"Sprite2D/ColorRect", "color", Color($Sprite2D/ColorRect.color, 0), 0.1)
	elif active:
		active = false
		player.scrap_count.text = str(int(player.scrap_count.text) + scraps)
		$"../..".difficulty += scraps
		$"../..".enemies.erase(self)
		$"../Audio".pitch_scale = randf_range(0.5, 1.8)
		$"../Audio".play()
		t.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
		t.tween_property(self, "scale", Vector2(0,0), 0.15)
		t.tween_callback(queue_free)


func _on_timer_timeout() -> void:
	print("timeout!")
	if player.positive and player.negative and connected and player.negative.scale != Vector2.ZERO:
		print("shorting...")
		player.short()
