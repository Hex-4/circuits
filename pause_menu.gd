extends Control

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CheckBox.button_pressed = settings.shake


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused:
			get_tree().paused = false
			hide()
			paused = false
		else:
			get_tree().paused = true
			show()
			paused = true


func _on_button_pressed() -> void:

	for i in range(%Life.life):
		%Life.decrease()


func _on_check_box_pressed() -> void:
	settings.shake = !settings.shake
