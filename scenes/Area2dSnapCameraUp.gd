extends Area2D

@onready var main_camera = $"../.."
@onready var up_arrow_sprite = $CenterContainer/Control/Sprite2D
@onready var sprite_default_y = up_arrow_sprite.position.y

func animate_arrow(a: Node2D) -> void:
	var t = Globals.create_smooth_tween()
	t.set_loops()
	t.tween_property(a, "position:y", sprite_default_y - 20, 0.2)
	t.tween_property(a, "position:y", sprite_default_y, 0.6)


func _ready():
	pass


func _on_area_entered(_area: Area2D) -> void:
	print("print")
	if main_camera.position.y > -270:
		up_arrow_sprite.visible = true
		animate_arrow(up_arrow_sprite)


func _on_area_exited(_area: Area2D) -> void:
	print("print")
	up_arrow_sprite.visible = false
