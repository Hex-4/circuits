extends Button

@export_file("*.tscn") var scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(switch)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func switch():
	get_tree().change_scene_to_file(scene)
