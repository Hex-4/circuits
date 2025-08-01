extends CharacterBody2D

@export var speed = 400
@export var radius = 600
@export_range(0.0, 1.0) var friction = 0.06
@export_range(0.0 , 1.0) var acceleration = 0.08
@export var separation_dist = 600


@onready var player = %Player

var connected = false:
	get:
		return connected
	set(value):
		if value == false and connected == true: # disconnect
			player.negative = null
		elif value == true and connected == false: # connect
			player.negative = self
		connected = value

func _physics_process(delta):
	if !player:
		player = get_node("../../Player")
	if player:
		# separation logic
		
		var separation_force = Vector2.ZERO
		
		for e in get_tree().get_nodes_in_group("enemy"):
			if e == self:
				continue
			if position.distance_to(e.position) <= separation_dist:
				separation_force += (-position.direction_to(e.position)) * (1 - position.distance_to(e.position) / separation_dist)
			
		
		var dir = position.direction_to(player.position)
		

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
	$"../..".spawn()
	queue_free()
