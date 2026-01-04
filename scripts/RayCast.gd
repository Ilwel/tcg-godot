extends RayCast2D

const SNAP_CAMERA_LAYER = 512
const CARD_SLOT_LAYER = 2

@onready var current_zone = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	global_position = mouse_pos
	target_position = Vector2(0, 1)
	force_raycast_update()
	if is_colliding():
		var zone = get_collider()
		print(zone.get_collision_layer())
		if zone != current_zone:
			if current_zone:
				current_zone.on_mouse_exit()
			current_zone = zone
			current_zone.on_mouse_enter()
	else:
		if current_zone:
			current_zone.on_mouse_exit()
			current_zone = null
