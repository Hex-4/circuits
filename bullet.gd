extends Area2D

@export var speed = 2000

var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = -Vector2.LEFT.rotated(rotation + $"../Player".rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group("attackable"):
		print("damage!!")
		body.damage()
