extends Node2D

var CardScene = preload("res://scenes/Card.tscn")

var cursor_grab = load("res://assets/kenney_cursor-pack/PNG/Outline/Default/hand_closed.png")
var cursor_open = load("res://assets/kenney_cursor-pack/PNG/Outline/Default/hand_open.png")
var cursor_point = load("res://assets/kenney_cursor-pack/PNG/Outline/Default/hand_point.png")
var player_match_controls = false

func snap_camera_up(camera: Camera2D, y_snap):
	var tween = Globals.create_smooth_tween()
	tween.tween_property(
		camera,
		"position:y",
		max(camera.position.y - y_snap, -y_snap),
		0.15
	)
	
func snap_camera_down(camera: Camera2D, y_snap):
	var tween = Globals.create_smooth_tween()
	tween.tween_property(
		camera,
		"position:y",
		min(camera.position.y + y_snap, y_snap),
		0.15
	)

func _intersect_point_with_mask(mask: int) -> Array:
	var space_state = get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collision_mask = mask
	return space_state.intersect_point(params)
	
func raycast_check_first_item(mask: int) -> Node:
	var result: Array = _intersect_point_with_mask(mask)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func handle_2d_perspective(sprite: Sprite2D, mouse_pos: Vector2, angle_x_max: float, angle_y_max: float):
	#var diff: Vector2 = (position + size) - mouse_pos
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, sprite.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, sprite.y, 0, 1)
	
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(-angle_y_max, angle_y_max, lerp_val_y))
	
	sprite.material.set_shader_parameter("x_rot", rot_y)
	sprite.material.set_shader_parameter("y_rot", rot_x)	

func pixel_perfect(v: Vector2) -> Vector2:
	return Vector2(round(v.x), round(v.y))

func create_smooth_tween() ->Tween:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	return tween

func load_deck_from_json(path: String = "res://assets/cards.json"):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Erro ao abrir arquivo " + path)
		return []

	var text := file.get_as_text()
	var parsed = JSON.parse_string(text)
	if parsed == null:
		push_error("JSON mal formatado!")
		return []

	return parsed
	
func load_deck_cards_from_json(path):
	var deck = load_deck_from_json(path)
	return deck.cards
	
func load_deck_runes_from_json(path):
	var deck = load_deck_from_json(path)
	var runes = []
	for rune_data in deck.runes:
		var rune_obj = {
			"type": rune_data,
			"state": "disabled"
		}
		runes.append(rune_obj)
	return runes
	
func get_card_data_by_id(id: String) -> Dictionary:
	var all_cards: Array = load_deck_from_json()

	for data in all_cards:
		if data["id"] == id:
			return data

	push_error("Carta com ID '" + id + "' não encontrada no JSON!")
	return {}

func create_card_from_data(data: Dictionary) -> Card:
	var card := CardScene.instantiate()

	card.card_id = data["id"]
	card.name = data["nome"]
	card.cost = data["custo"]
	card.atk = data["atk"]
	card.hp = data["hp"]
	card.description = data["descricao"]

	var art_path = data.get("art", "res://assets/card/arts/NoArt.png")
	card.art.texture = load(art_path)
	return card
	
func create_card_from_id(id: String) -> Card:
	var data := get_card_data_by_id(id)
	if data.is_empty():
		return null

	var card := CardScene.instantiate()

	card.card_id = data["id"]
	card.card_name = data["nome"]
	card.cost = data["custo"]
	card.atk = data["atk"]
	card.hp = data["hp"]
	card.theme = data["theme"]

	var art_path = data.get("art", "res://assets/card/arts/NoArt.png")
	var art_node: Sprite2D = card.get_node("FaceCard/ArtCanvas/Art")
	art_node.texture = load(art_path)

	return card
	
func _set_intensity(value, sprite):
	var c = sprite.modulate
	c.r = value
	c.g = value
	c.b = value
	return c

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
