extends Node

var CardScene = preload("res://scenes/Card.tscn")

func pixel_perfect(v: Vector2) -> Vector2:
	return Vector2(round(v.x), round(v.y))

func create_smooth_tween() ->Tween:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
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

	var art_path = data.get("art", "res://assets/card/arts/NoArt.png")
	print(art_path)
	var art_node: Sprite2D = card.get_node("FaceCard/ArtCanvas/Art")
	art_node.texture = load(art_path)

	return card

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
