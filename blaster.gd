extends Sprite2D

@export var bullet: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("a") and $Timer.time_left == 0:
		
		$Audio.play()
		var b = bullet.instantiate()
		
		b.transform = global_transform
		b.rotation = get_parent().rotation
		
		owner.add_child(b)
		
		var t = create_tween()
		t.tween_property($Flash, "scale", Vector2(1,1), 0.05)
		t.tween_property($Flash, "scale", Vector2(0,0), 0.1)
		
		$Timer.start()
