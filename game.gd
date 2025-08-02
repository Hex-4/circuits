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
	med = 5,
	big = 0,
}

var rng: RandomNumberGenerator

@export var spawn_chance = 0.3

@export var nearby_chance = 0.05

@export var pickup_chance = 0.6

@export var max_pickups = 30

var enemies: Array[CharacterBody2D] = []

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
	print("PLAYER READY")
	for a: int in range(100): # X pairs
		print("Trying to spawn", a)
		spawn()
		print("spawned something")

func spawn():
	print("Spawn function start")
	if len(enemies) < 300:
		if !rng:
			print("RNG not initialized. Initializing...")
			rng = RandomNumberGenerator.new()
		var result = weights.keys()[rng.rand_weighted(weights.values())]
		print("Selected enemy type:", result)

		var p_position: Vector2
		
		if randf_range(0, 1) > nearby_chance:
			print("Spawning far")
			p_position = Vector2(randi_range(-14000, 11500), randi_range(13500, -11500))
		else:
			print("Spawning nearby")
			var rect: Rect2 = $Player/ActiveRadius/CollisionShape2D.shape.get_rect().grow(1000)
			p_position = Vector2(randi_range(rect.position.x, rect.position.x+rect.size.x), randi_range(rect.position.y, rect.position.x+rect.size.y))
		
		print("Position picked:", p_position)
		
		match result:
			"smol":
				print("Spawning smol")
				spawn_smol(p_position)
			"med":
				print("Spawning med")
				spawn_med(p_position)
			"big":
				print("Spawning big")
				spawn_big(p_position)
			_:
				print("Fallback: Spawning smol")
				spawn_smol(p_position)
		
		if randf_range(0, 1) < pickup_chance and len($Pickups.get_children()) <= max_pickups:
			print("Spawning pickup")
			spawn_pickup(p_position)
		else:
			print("Skipping pickup spawn")
	else:
		print("Too many enemies! Skipping spawn.")
	print("Spawn function end")

func spawn_smol(pos):
	if not plus_smol or not minus_smol:
		print("Missing scene(s): plus_smol or minus_smol")
		return

	var p = plus_smol.instantiate()
	var n = minus_smol.instantiate()
	if !p or !n:
		print("Instantiation failed for smol enemies")
		return

	p.position = pos
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))

	if p and n:
		$Nodes.call_deferred("add_child", p)
		$Nodes.call_deferred("add_child", n)

	if p.position.distance_to($Player.position) < 900 or n.position.distance_to($Player.position) < 900:
		p.queue_free()
		n.queue_free()
		return

	enemies.append(p)
	enemies.append(n)

func spawn_med(pos):
	print("spawn_med at", pos)
	var n
	var p
	
	p = plus_med.instantiate()
	print("Plus med instantiated")

	p.position = pos
	
	if p:
		$Nodes.call_deferred("add_child", p)
	print("Plus med added")
	
	n = minus_med.instantiate()
	print("Minus med instantiated")
	
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))
	
	if n:
		$Nodes.call_deferred("add_child", n)
	print("Minus med added")
	
	if p.position.distance_to($Player.position) < 900 or n.position.distance_to($Player.position) < 900:
		print("Too close to player, freeing meds")
		p.queue_free()
		n.queue_free()
		print("Respawning after free")
		spawn()
	else:
		print("Med enemies added")
		enemies.append(p)
		enemies.append(n)
		
func spawn_big(pos):
	print("spawn_big at", pos)
	var n
	var p
	
	p = plus_big.instantiate()
	print("Plus big instantiated")

	p.position = pos
	
	if p:
		$Nodes.call_deferred("add_child", p)
	print("Plus big added")
	
	n = minus_big.instantiate()
	print("Minus big instantiated")
	
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))
	
	if n:
		$Nodes.call_deferred("add_child", n)
	print("Minus big added")
	
	if p.position.distance_to($Player.position) < 900 or n.position.distance_to($Player.position) < 900:
		print("Too close to player, freeing bigs")
		p.queue_free()
		n.queue_free()
		print("Respawning after free")
		spawn()
	else:
		print("Big enemies added")
		enemies.append(p)
		enemies.append(n)
		
func spawn_pickup(pos):
	print("spawn_pickup at", pos)
	var pickup
	
	pickup = pickup_scene.instantiate()
	print("Pickup instantiated")
	
	pickup.position = pos
	
	pickup.type = ["speed", "shoot", "life", "bomb"].pick_random()
	print("Pickup type:", pickup.type)
	
	$Pickups.call_deferred("add_child", pickup)
	print("Pickup added to scene")
