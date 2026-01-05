extends Node2D

@onready var up_arrow_sprite = $Area2D/CenterContainer/Control/Sprite2D
@onready var sprite_default_y = up_arrow_sprite.position.y
@onready var main_camera = $".."
@onready var snap_up_area = $Area2D
@onready var in_area = false

const SNAP_AREA_MASK = 1024

func animate_arrow(a: Node2D) -> void:
	var t = Globals.create_smooth_tween()
	t.set_loops()
	t.tween_property(a, "position:y", sprite_default_y - 20, 0.2)
	t.tween_property(a, "position:y", sprite_default_y, 0.6)

func _input(event):
	if event is InputEventMouseMotion:
		var snap_area = Globals.raycast_check_first_item(SNAP_AREA_MASK)
		if snap_area and not in_area and Globals.player_match_controls:
			in_area = true
			if main_camera.position.y > -270:
				Input.set_custom_mouse_cursor(Globals.cursor_point)
				up_arrow_sprite.visible = true
				animate_arrow(up_arrow_sprite)
		elif not snap_area and in_area:
			Input.set_custom_mouse_cursor(Globals.cursor_open)
			up_arrow_sprite.visible = false
			in_area = false

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and Globals.player_match_controls:
		Globals.snap_camera_up(main_camera, 270)
