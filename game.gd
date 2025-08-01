extends Node2D

@export var plus_smol: PackedScene
@export var minus_smol: PackedScene

@export var offset = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_ready() -> void:
	var p
	var n
	for a: int in range(100): # X pairs
		spawn()

func spawn():
	var n
	var p
	
	p = plus_smol.instantiate()

	p.position = Vector2(randi_range(-18750, 17000), randi_range(16500, -14000))
	
	$Nodes.add_child(p)
	
	n = minus_smol.instantiate()
	
	n.position = p.position + Vector2(randi_range(-offset, offset), randi_range(-offset, offset))
	
	$Nodes.add_child(n)
	
