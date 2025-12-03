@tool
extends Control

signal click

@onready var player = $AnimationPlayer
@onready var sprite_heads = $SpriteHeads
@onready var sprite_tails = $SpriteTails
@onready var bright_animation = $BrightAnimation
@onready var is_flipping = false
@export var face_parm:bool = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	bright_animation.visible = false
	choose_face(face_parm)
	pass

func random_face():
	return randi() % 2 == 0

func flip():
	is_flipping = true
	var face_result = random_face()
	player.play('coin_flip-loop')
	if face_result:
		await get_tree().create_timer(1.0).timeout
		player.stop()
	else:
		await get_tree().create_timer(1.5).timeout
		player.stop()
		
	choose_face(face_result)
	is_flipping = false
	return face_result

func choose_face(face: bool):
	if face:
		sprite_heads.visible = true
		sprite_tails.visible = false
		sprite_heads.scale = Vector2.ONE
	else:
		sprite_heads.visible = false
		sprite_tails.visible = true
		sprite_tails.scale = Vector2.ONE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("click")
			emit_signal("click", face_parm)

func _on_area_2d_mouse_entered() -> void:
	if not is_flipping:
		bright_animation.visible = true
		bright_animation.play()
		sprite_heads.modulate = Globals._set_intensity(2, sprite_heads)
		sprite_tails.modulate = Globals._set_intensity(2, sprite_tails)

func _on_area_2d_mouse_exited() -> void:
	if not is_flipping:
		bright_animation.stop()
		bright_animation.visible = false
		sprite_heads.modulate = Globals._set_intensity(1, sprite_heads)
		sprite_tails.modulate = Globals._set_intensity(1, sprite_tails)
