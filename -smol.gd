extends CharacterBody2D

@export var speed = 400
@export var radius = 600
@export_range(0.0, 1.0) var friction = 0.06
@export_range(0.0 , 1.0) var acceleration = 0.08
@export var separation_dist = 600
@export var hits = 1
@export var scraps = 2
var active = true

@onready var player

@onready var max_hits = hits

var connected = false:
	get:
		return connected
	set(value):
		if value == false and connected == true: # disconnect
			player.negative = null
			$"../DisconnectAudio".play()
		elif value == true and connected == false: # connect
			player.negative = self
			$"../ConnectAudio".play()
		connected = value
		
func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func separate():
	var separation_force = Vector2.ZERO
		
	for e in get_tree().get_nodes_in_group("enemy"):
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
		var separation_force = separate()

		dir += separation_force * 250
		dir = dir.normalized()
		if position.distance_to(player.position) <= radius or player.negative:
			velocity.x = lerp(velocity.x, 0.0, friction)
			velocity.y = lerp(velocity.y, 0.0, friction)
		else:
			velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
			velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
		
		move_and_slide()
	
func _process(delta: float) -> void:
	if player:
		$Line2D.points = [$Line2D.to_local(position), $Line2D.to_local(player.position)]
		if position.distance_to(player.position) <= radius and not player.negative:
			connected = true
			$Line2D.visible = true
		if position.distance_to(player.position) > radius:
			connected = false
			$Line2D.visible = false
		
	

func damage():
	if !player:
		player = get_node("../../Player")
	hits -= 1
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_EXPO)
	if randf_range(0, 1) < $"../..".spawn_chance:
		$"../..".spawn()
	t.tween_property($"Sprite2D/ColorRect", "color", Color($Sprite2D/ColorRect.color, 1), 0.05)
	if hits > 0:
		t.tween_property($"Sprite2D/ColorRect", "color", Color($Sprite2D/ColorRect.color, 0), 0.1)
	elif active:
		active = false
		if player.negative == self:
			player.negative = null
		player.scrap_count.text = str(int(player.scrap_count.text) + scraps)
		$"../..".difficulty += scraps
		player.get_node("Camera").add_trauma(0.3)
		$"../Audio".pitch_scale = randf_range(0.5, 1.8)
		$"../Audio".play()
		t.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
		t.tween_property(self, "scale", Vector2(0,0), 0.2)
		t.tween_callback(queue_free)
