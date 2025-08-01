extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy"):
			
			body.set_process(true)
			body.set_physics_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.set_process(true)
		body.set_physics_process(true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.set_process(false)
		body.set_physics_process(false)
