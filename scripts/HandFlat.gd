@tool
class_name HandFlat extends Node2D

@export var card_manager: CardManager
@export var hand_player: Match.PlayerType = Match.PlayerType.Player
@export var ROW_Y: float = 510.0                # altura da mão (ajuste livre)

const CARD_SPACING: float = 110.0       # distância entre as cartas
const HOVER_OFFSET: float = 50.0

var hand: Array[Card] = []

func add_card(card: Card, source: Node2D) -> void:
	hand.append(card)
	card.get_node("CardArea/CardCollision").disabled = true
	if card_manager:
		card_manager.add_child(card)
	card.global_position = source.global_position
	card.rotation = source.rotation
	reposition_cards_flat()

func remove_card(card: Card) -> Card:
	if card in hand:
		hand.erase(card)
		if card_manager:
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
	card.shadow.position = face_target
	tween.tween_property(card, "global_position", target_pos, 0.15)
	tween.tween_property(card, "rotation", 0.0, 0.15)
	return tween

func _enable_card_collision_if_local_player(card: Card) -> void:
	if hand_player == Match.PlayerType.Player:
		card.get_node("CardArea/CardCollision").disabled = false

func _calc_start_x(count: int) -> float:
	var screen_size := get_viewport_rect().size
	var center_x := screen_size.x / 2.0
	var total_width := (count - 1) * CARD_SPACING
	return center_x - total_width / 2.0

func reposition_cards_flat(highlight: Card = null) -> void:
	var count := hand.size()
	if count == 0:
		return

	var start_x := _calc_start_x(count)

	for i in range(count):
		var card: Card = hand[i]
		var target_pos := Vector2(start_x + i * CARD_SPACING, ROW_Y)
		var is_highlighting := (card == highlight)
		var tween := update_card_transform_flat(card, target_pos, is_highlighting)
		# connect the finished signal to enable collision only for player hand
		tween.finished.connect(_enable_card_collision_if_local_player.bind(card))

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
