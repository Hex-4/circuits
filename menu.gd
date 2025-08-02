extends Control

@export var trill: AudioStreamMP3

@export_file("*.tscn") var scene

var loaded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loaded = load(scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch():
	get_tree().change_scene_to_packed(loaded)

func _on_button_pressed() -> void:
	var t = create_tween()
	t.tween_property($Audio, "volume_linear", 0, 0.05)
	t.tween_callback($Audio.set_stream.bind(trill))
	t.tween_property($Audio, "volume_linear", 1, 0)
	t.tween_callback($Audio.play)
	t.tween_property(self, "position", Vector2(position.x - 1200, position.y), 2.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	t.tween_callback(switch)
