extends Area2D

@export var type = "speed"
@export var base_atlas: AtlasTexture = preload("res://pickup.atlastex")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var unique_atlas = base_atlas.duplicate()
	$Sprite2D.texture = unique_atlas
	print(type)
	match type:
		"speed":
			$Sprite2D.texture.region.position.y = 0
			print("hi")
		"shoot":
			$Sprite2D.texture.region.position.y = 1 * 64
		"life":
			$Sprite2D.texture.region.position.y = 2 * 64
		"bomb":
			$Sprite2D.texture.region.position.y = 3 * 64


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !body.held_pickup:
			body.pickup(type)
			var t = get_tree().create_tween()
			t.set_ease(Tween.EASE_IN)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property(self, "scale", Vector2(0,0), 0.2)
			t.tween_callback(queue_free)
