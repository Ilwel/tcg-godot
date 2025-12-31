class_name Deck extends Node2D

@export var player_hand: HandFlat
@export var player_type: Match.PlayerType

@onready var card_scene: PackedScene = preload("res://scenes/Card.tscn")
@onready var deck_size_lbl: Label = $DeckSizeContainer/DeckSizeLbl
@onready var deck_size_container: CanvasItem = $DeckSizeContainer
@onready var deck_collision: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	if player_type == Match.PlayerType.Enemy:
		deck_collision.disabled = true
		_import_current_enemy_deck()
	else:
		_import_current_player_deck()
	$Area2D.input_event.connect(_on_area_input)
	deck_size_container.modulate.a = 0.0
	
func _import_current_player_deck():
	import_ids(Globals.load_deck_cards_from_json("res://assets/decks/init_deck.json"))
	randomize()
	shuffle()
	
func _import_current_enemy_deck():
	import_ids(Globals.load_deck_cards_from_json("res://assets/decks/init_deck.json"))
	randomize()
	shuffle()

func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		draw_card()

func _can_draw_card(force_draw: bool) -> bool:
	var turn_phase = Match.get_current_turn_phase()
	var current_player = Match.get_current_player()
	return (turn_phase == Match.TurnPhaseType.Draw and current_player == Match.PlayerType.Player) or force_draw

func draw_card(force_draw: bool = false) -> void:
	if not _can_draw_card(force_draw):
		return

	var cards: Array = Match.get_player_deck(player_type)
	if cards.size() == 0:
		print("Deck vazio!")
		return

	# remove a última carta (topo da pilha)
	var card_id: String = cards.pop_back()
	if card_id:
		var card: Card = Globals.create_card_from_id(card_id)
		if player_type == Match.PlayerType.Enemy:
			card.face_up = false
		player_hand.add_card(card, self)
		if not force_draw:
			Match.set_turn_phase(Match.TurnPhaseType.Main)
		
func draw_n(n: int, force_draw: bool = false):
	for i in range(n):
		draw_card(force_draw)
		await get_tree().create_timer(0.3).timeout

func import_ids(id_list: Array) -> void:
	var cards: Array = Match.get_player_deck(player_type)
	cards.clear()
	for id_str in id_list:
		cards.append(id_str)

func import_data(data_list: Array) -> void:
	var cards: Array = Match.get_player_deck(player_type)
	cards.clear()
	for data in data_list:
		cards.append(data["id"])

func shuffle() -> void:
	var cards: Array = Match.get_player_deck(player_type)
	var n: int = cards.size()
	for i in range(n - 1, 0, -1):
		var j: int = randi() % (i + 1)
		var temp: String = cards[i]
		cards[i] = cards[j]
		cards[j] = temp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	deck_size_lbl.text = str(Match.get_player_deck(player_type).size())
	pass

func _on_area_2d_mouse_entered() -> void:
	var tween = Globals.create_smooth_tween()
	tween.tween_property(deck_size_container, 'modulate:a', 1.0, 0.15)


func _on_area_2d_mouse_exited() -> void:
	var tween = Globals.create_smooth_tween()
	tween.tween_property(deck_size_container, 'modulate:a', 0.0, 0.15)
