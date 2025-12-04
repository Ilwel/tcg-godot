extends Node

var CardScene = preload("res://scenes/Card.tscn")

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

func load_cards_from_json(path: String = "res://assets/cards.json") -> Array:
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
	
func get_card_data_by_id(id: String) -> Dictionary:
	var all_cards: Array = load_cards_from_json()

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
func _process(delta: float) -> void:
	pass
