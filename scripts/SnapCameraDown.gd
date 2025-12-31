extends Node

@onready var up_arrow_sprite = $Area2D/CenterContainer/Control/Sprite2D
@onready var sprite_default_y = up_arrow_sprite.position.y
@onready var main_camera = $".."

func animate_arrow(a: Node2D) -> void:
	var t = Globals.create_smooth_tween()
	t.set_loops()
	t.tween_property(a, "position:y", sprite_default_y + 20, 0.2)
	t.tween_property(a, "position:y", sprite_default_y, 0.6)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass




func _on_area_2d_mouse_entered() -> void:
	print(main_camera.position.y)
	if main_camera.position.y < 270:
		up_arrow_sprite.visible = true
		animate_arrow(up_arrow_sprite)


func _on_area_2d_mouse_exited() -> void:
	up_arrow_sprite.visible = false


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Globals.snap_camera_down(main_camera, 270)
