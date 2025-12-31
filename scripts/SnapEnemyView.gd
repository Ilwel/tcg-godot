extends Node

@onready var main_camera = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var tween = Globals.create_smooth_tween()
	tween.tween_property(
		main_camera,
		"position:y",
		max(main_camera.position.y - 270, -270),
		0.15
	)
