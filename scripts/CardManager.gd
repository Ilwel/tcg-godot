class_name CardManager extends Node2D

const COLLISION_MASK_CARD: int = 1
const COLLISION_MASK_CARD_SLOT: int = 2

@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var card_being_dragged: Card = null
@onready var is_hovering_on_card: bool = false
@onready var is_highlighting_a_card: bool = false
@onready var last_hovered_card: Card = null

@export var player_hand_reference: HandFlat

func _get_highest_z_card(results: Array) -> Card:
	if results.size() == 0:
		return null
	var highest: Card = results[0].collider.get_parent()
	var highest_index: int = highest.z_index
	for i in range(1, results.size()):
		var current: Card = results[i].collider.get_parent()
		if current.z_index > highest_index:
			highest = current
			highest_index = current.z_index
	return highest

func _intersect_point_with_mask(mask: int) -> Array:
	var space_state = get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collision_mask = mask
	return space_state.intersect_point(params)

func raycast_check_for_card() -> Card:
	var result: Array = _intersect_point_with_mask(COLLISION_MASK_CARD)
	if result.size() > 0:
		return _get_highest_z_card(result)
	return null

func raycast_check_for_card_slot() -> Node:
	var result: Array = _intersect_point_with_mask(COLLISION_MASK_CARD_SLOT)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if card_being_dragged:
		card_being_dragged.handle_shadow()
		var mouse_pos: Vector2 = get_global_mouse_position()
		card_being_dragged.global_position = Vector2(
			clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y)
		)
		card_being_dragged.rotation = 0
	elif player_hand_reference and player_hand_reference is HandFlat and not is_highlighting_a_card:
		player_hand_reference.reposition_cards_flat()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card: Card = raycast_check_for_card()
			if card:
				start_drag(card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card: Card) -> void:
	Input.set_custom_mouse_cursor(Globals.cursor_grab)
	card_being_dragged = card
	if card_being_dragged and card_being_dragged.face:
		card_being_dragged.face.position = card_being_dragged.default_face_pos

func finish_drag() -> void:
	Input.set_custom_mouse_cursor(Globals.cursor_open)
	if not card_being_dragged:
		return
	var card_slot_found: CardSlot = raycast_check_for_card_slot()
	var card: Card = card_being_dragged
	card.reset_shadow()
	card_being_dragged = null
	if player_hand_reference and player_hand_reference is HandFlat:
		if card_slot_found and not card_slot_found.card_in_slot:
			player_hand_reference.remove_card(card)
			card.get_node("CardArea/CardCollision").disabled = true
			card_slot_found.add_child(card)
			card_slot_found.move_child(card, 1)
			card.z_index = -1
			card.position = Vector2(50, 70)
			card_slot_found.card_in_slot = true
			is_hovering_on_card = false
			card.handle_ace_details(card_slot_found.ace_slot)
	is_highlighting_a_card = false

func connect_card_signals(card: Card) -> void:
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	var window = get_window()
	if window and not window.mouse_exited.is_connected(on_hover_off_window):
		window.mouse_exited.connect(on_hover_off_window)
	if window and not window.mouse_entered.is_connected(on_hover_on_window):
		window.mouse_entered.connect(on_hover_on_window)

func on_hovered_over_card(card: Card) -> void:
	if not is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
		last_hovered_card = card

func on_hovered_off_card(card: Card) -> void:
	if card == last_hovered_card:
		var new_card_hovered: Card = raycast_check_for_card()
		if card != new_card_hovered:
			highlight_card(card, false)
			if new_card_hovered:
				highlight_card(new_card_hovered, true)
				last_hovered_card = new_card_hovered
			else:
				is_hovering_on_card = false
				last_hovered_card = null

# window mouse event handlers
func on_hover_off_window() -> void:
	if last_hovered_card:
		highlight_card(last_hovered_card, false)
	last_hovered_card = null

func on_hover_on_window() -> void:
	var resume_hover_card: Card = raycast_check_for_card()
	if resume_hover_card:
		highlight_card(resume_hover_card, true)
		last_hovered_card = resume_hover_card

func highlight_card(card: Card, hovered: bool) -> void:
	if not card or card_being_dragged:
		return
	if hovered and Globals.player_match_controls:
		card.z_index = 1
		card.show_details(true)
		if player_hand_reference and player_hand_reference is HandFlat:
			Input.set_custom_mouse_cursor(Globals.cursor_point)
			player_hand_reference.reposition_cards_flat(card)
			is_highlighting_a_card = true
	else:
		card.z_index = 0
		card.show_details(false)
		if player_hand_reference and player_hand_reference is HandFlat:
			player_hand_reference.reposition_cards_flat()
			is_highlighting_a_card = false
			Input.set_custom_mouse_cursor(Globals.cursor_open)
