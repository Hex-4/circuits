extends Node2D

var life = 3
@onready var capsules: Array[Node] = get_children()
@export var loser: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func decrease():

	capsules[life-1].texture.region.position.y = 24
	
	life -= 1
	
	if life == 0:
		var t = create_tween()
		t.tween_interval(1.3)
		t.tween_callback(get_tree().change_scene_to_packed.bind(loser))

	
func increase():
	print("increasing")
	capsules[life].texture.region.position.y = 0
	
	life += 1
	
	
