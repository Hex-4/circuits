extends Node2D

@export var plus_smol: PackedScene
@export var minus_smol: PackedScene
@export var plus_med: PackedScene
@export var minus_med: PackedScene
@export var plus_big: PackedScene
@export var minus_big: PackedScene


@export var pickup_scene: PackedScene

@export var offset = 200

@export var weights = {
	smol = 95,
	med = 10,
	big = 0,
}

var rng: RandomNumberGenerator

@export var spawn_chance = 0.25

@export var nearby_chance = 0.1

@export var pickup_chance = 0.6

@export var max_pickups = 30



@export var difficulty = 0:
	get:
		return difficulty
	set(value):
		reweight(value - difficulty, value)
		difficulty = value
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func reweight(difference, value):
	weights.med += difference * 0.13
	
	spawn_chance += difference * 0.01
	
	if $Timer.wait_time > 1.5:
		$Timer.wait_time -= difference * 0.02
		
	if nearby_chance < 0.8:
		nearby_chance += difference * 0.01
		
	if value > 60:
		weights.big += difference * 0.1
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_ready() -> void:

	for a: int in range(100): # X pairs

		spawn()




func spawn():

	if len($"Player/Bomb Area".get_overlapping_bodies()) < 100:
		print("SPAWINGINGNGNGNG")
		if !rng:

			rng = RandomNumberGenerator.new()
		var result = weights.keys()[rng.rand_weighted(weights.values())]


		var p_position: Vector2
		
		if randf_range(0, 1) > nearby_chance:

			p_position = Vector2(randi_range(-14000, 11500), randi_range(13500, -11500))
		else:

			var rect: Rect2 = $Player/ActiveRadius/CollisionShape2D.shape.get_rect().grow(1000)
			p_position = Vector2(randi_range(rect.position.x, rect.position.x+rect.size.x), randi_range(rect.position.y, rect.position.x+rect.size.y))
		

		
		match result:
			"smol":

				spawn_smol(p_position)
			"med":

				spawn_med(p_position)
			"big":

				spawn_big(p_position)
			_:

				spawn_smol(p_position)
		
		if randf_range(0, 1) < pickup_chance and len($Pickups.get_children()) <= max_pickups:

			spawn_pickup(p_position)




func spawn_smol(pos):


	var p = plus_smol.instantiate()
	var n = minus_smol.instantiate()


	p.position = pos
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))

	if p and n:
		if p.position.distance_to($Player.position) > 900 and n.position.distance_to($Player.position) > 900:
			$Nodes.call_deferred("add_child", p)
			$Nodes.call_deferred("add_child", n)
		else:
			p.queue_free()
			n.queue_free()



func spawn_med(pos):

	var n
	var p
	
	p = plus_med.instantiate()


	p.position = pos
	
	if p:
		if p.position.distance_to($Player.position) > 900:
			$Nodes.call_deferred("add_child", p)
		else:
			p.queue_free()
		

	
	n = minus_med.instantiate()

	
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))
	
	if n:
		if n.position.distance_to($Player.position) > 900:
			$Nodes.call_deferred("add_child", n)
		else:
			n.queue_free()

	


		
func spawn_big(pos):

	var n
	var p
	
	p = plus_big.instantiate()


	p.position = pos
	
	if p:
		if p.position.distance_to($Player.position) > 900:
			$Nodes.call_deferred("add_child", p)
		else:
			p.queue_free()

	
	n = minus_big.instantiate()

	
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))
	
	if n:
		if n.position.distance_to($Player.position) > 900:
			$Nodes.call_deferred("add_child", n)
		else:
			n.queue_free()

	

		
func spawn_pickup(pos):

	var pickup
	
	pickup = pickup_scene.instantiate()

	
	pickup.position = pos
	
	pickup.type = ["speed", "shoot", "life", "bomb"].pick_random()

	
	$Pickups.call_deferred("add_child", pickup)
