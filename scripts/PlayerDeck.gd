class_name PlayerDeck extends Node2D

var cards = ['card', 'card', 'card', 'card', 'card', 'card', 'card', 'card', 'card', 'card', 'card', 'card', 'card', 'card', 'card']

@export var player_hand: Hand

@onready var card_scene: PackedScene = preload("res://scenes/Card.tscn")
@onready var deck_size_lbl = $DeckSizeContainer/DeckSizeLbl
@onready var deck_size_container = $DeckSizeContainer

func _ready() -> void:
	$Area2D.input_event.connect(_on_area_input)
	deck_size_container.modulate.a = 0.0

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		draw_card()

func draw_card():
	if cards.is_empty():
		print("Deck vazio!")
		return

	# remove a última carta (topo da pilha)
	var card_id: String = cards.pop_back()
	if card_id:
		var card = card_scene.instantiate()
		player_hand.add_card(card, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	deck_size_lbl.text = str(cards.size())
	pass


func _on_area_2d_mouse_entered() -> void:
	var tween = Globals.create_smooth_tween()
	tween.tween_property(deck_size_container, 'modulate:a', 1.0, 0.15)


func _on_area_2d_mouse_exited() -> void:
	var tween = Globals.create_smooth_tween()
	tween.tween_property(deck_size_container, 'modulate:a', 0.0, 0.15)
