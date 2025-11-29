@tool
class_name HandFlat extends Node2D

@export var card_manager: CardManager

const SCREEN_WIDTH := 960
const BASE_Y := 1000              	# altura da linha da mão (ajusta no gosto)
const CARD_SPACING := 110       	# distância entre as cartas
const ROW_Y := 510.0                # altura da mão (ajuste livre)

const HOVER_OFFSET = 50

var hand: Array = []

func add_card(card: Card, source: Node2D):
	hand.push_back(card)
	card.get_node("CardArea/CardCollision").disabled = true
	card_manager.add_child(card)
	card.global_position = source.global_position
	card.rotation = source.rotation
	reposition_cards_flat()
	
func remove_card(card: Card) -> Card:
	if card in hand:
		hand.erase(card)
		card_manager.remove_child(card)
		reposition_cards_flat()	
	return card

func update_card_transform_flat(card: Card, target_pos: Vector2, is_highlighting: bool) -> Tween:
	target_pos = Vector2(round(target_pos.x), round(target_pos.y))
	var tween := Globals.create_smooth_tween()

	var face_target: Vector2 = card.default_face_pos
	if is_highlighting:
		face_target.y -= HOVER_OFFSET

	tween.tween_property(card.face, "position", face_target, 0.15)
	tween.tween_property(card, "global_position", target_pos, 0.15)
	tween.tween_property(card, "rotation", 0.0, 0.15)
	return tween
	
func after_add_card(card: Card):
	card.get_node("CardArea/CardCollision").disabled = false

func reposition_cards_flat() -> void:
	var count := hand.size()
	if count == 0:
		return

	var screen_size := get_viewport().get_visible_rect().size
	var center_x := screen_size.x / 2.0
	var total_width := (count - 1) * CARD_SPACING
	var start_x := center_x - total_width / 2.0

	for i in range(count):
		var card = hand[i]
		var target_pos := Vector2(start_x + i * CARD_SPACING, ROW_Y)
		var tween = update_card_transform_flat(card, target_pos, false)
		tween.finished.connect(after_add_card.bind(card))

func reposition_cards_flat_with_highlight(highlight: Card) -> void:
	var count := hand.size()
	if count == 0:
		return
	
	var screen_size := get_viewport().get_visible_rect().size
	var center_x := screen_size.x / 2.0
	var total_width := (count - 1) * CARD_SPACING
	var start_x := center_x - total_width / 2.0

	for i in range(count):
		var card = hand[i]
		var target_pos := Vector2(start_x + i * CARD_SPACING, ROW_Y)
		var is_highlighting = (card == highlight)
		update_card_transform_flat(card, target_pos, is_highlighting)

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
