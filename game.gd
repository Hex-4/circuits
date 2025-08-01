extends Node2D

@export var plus_smol: PackedScene
@export var minus_smol: PackedScene
@export var plus_med: PackedScene
@export var minus_med: PackedScene

@export var offset = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_ready() -> void:

	for a: int in range(100): # X pairs
		spawn()
	for a: int in range(30): # X pairs
		spawn_med()

func spawn():
	var n
	var p
	
	p = plus_smol.instantiate()

	p.position = Vector2(randi_range(-18750, 17000), randi_range(16500, -14000))
	
	$Nodes.add_child(p)
	
	n = minus_smol.instantiate()
	
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))
	
	$Nodes.add_child(n)
	
	if p.position.distance_to($Player.position) < 1000 or n.position.distance_to($Player.position) < 1000:
		p.queue_free()
		n.queue_free()
		return
		

func spawn_med():
	var n
	var p
	
	p = plus_med.instantiate()

	p.position = Vector2(randi_range(-18750, 17000), randi_range(16500, -14000))
	
	$Nodes.add_child(p)
	
	n = minus_med.instantiate()
	
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))
	
	$Nodes.add_child(n)
	
	if p.position.distance_to($Player.position) < 1000 or n.position.distance_to($Player.position) < 1000:
		p.queue_free()
		n.queue_free()
		spawn_med()

func _on_timer_timeout() -> void:
	spawn()
