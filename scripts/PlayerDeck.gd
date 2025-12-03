class_name PlayerDeck extends Node2D

@export var player_hand: HandFlat
@export var player_deck: Match.PlayerType

@onready var card_scene: PackedScene = preload("res://scenes/Card.tscn")
@onready var deck_size_lbl = $DeckSizeContainer/DeckSizeLbl
@onready var deck_size_container = $DeckSizeContainer

func _ready() -> void:
	import_ids(Globals.load_cards_from_json("res://assets/test_deck.json"))
	randomize()
	shuffle()
	$Area2D.input_event.connect(_on_area_input)
	deck_size_container.modulate.a = 0.0

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		draw_card()

func draw_card():
	if Match.players[player_deck]["cards"].is_empty():
		print("Deck vazio!")
		return

	# remove a última carta (topo da pilha)
	var card_id: String = Match.players[player_deck]["cards"].pop_back()
	if card_id:
		var card = Globals.create_card_from_id(card_id)
		player_hand.add_card(card, self)
		
func draw_n(n: int):
	for i in range(n):
		draw_card()
		await get_tree().create_timer(0.3).timeout

func import_ids(id_list: Array) -> void:
	Match.players[player_deck]["cards"] = id_list.duplicate()

func import_data(data_list: Array) -> void:
	Match.players[player_deck]["cards"].clear()
	for data in data_list:
		Match.players[player_deck]["cards"].append(data["id"])

func shuffle() -> void:
	var n = Match.players[player_deck]["cards"].size()
	for i in range(n - 1, 0, -1):
		var j := randi() % (i + 1)
		var temp = Match.players[player_deck]["cards"][i]
		Match.players[player_deck]["cards"][i] = Match.players[player_deck]["cards"][j]
		Match.players[player_deck]["cards"][j] = temp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	deck_size_lbl.text = str(Match.players[player_deck]["cards"].size())
	pass

func _on_area_2d_mouse_entered() -> void:
	var tween = Globals.create_smooth_tween()
	tween.tween_property(deck_size_container, 'modulate:a', 1.0, 0.15)


func _on_area_2d_mouse_exited() -> void:
	var tween = Globals.create_smooth_tween()
	tween.tween_property(deck_size_container, 'modulate:a', 0.0, 0.15)
