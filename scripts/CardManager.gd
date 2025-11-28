class_name CardManager extends Node2D

const COLLISION_MASK_CARD = 1	
const COLLISION_MASK_CARD_SLOT = 2

@onready var screen_size = get_viewport_rect().size
@onready var card_being_dragged: Card = null
@onready var is_hovering_on_card = false
@onready var is_highlighting_a_card = false
@onready var last_hovered_card = null

@export var player_hand_reference:  HandFlat

func get_highest_z(result):
	var highest_z_card =  result[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, result.size()):
		var current_card = result[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
	
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var paramters = PhysicsPointQueryParameters2D.new()
	paramters.position = get_global_mouse_position()
	paramters.collide_with_areas = true
	paramters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(paramters)
	if result.size() > 0:
		return get_highest_z(result)
	return null
	
func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var paramters = PhysicsPointQueryParameters2D.new()
	paramters.position = get_global_mouse_position()
	paramters.collide_with_areas = true
	paramters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(paramters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = Vector2(
			clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y)
		)
		card_being_dragged.rotation = 0
	elif is_instance_of(player_hand_reference, HandFlat) and not is_highlighting_a_card:
		player_hand_reference.reposition_cards_flat()
		
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				start_drag(card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card: Card):
	card_being_dragged = card
	card_being_dragged.face.position = card_being_dragged.default_face_pos
	
func finish_drag():
	var card_slot_found = raycast_check_for_card_slot()
	var card = card_being_dragged
	card_being_dragged = null
	if is_instance_of(player_hand_reference, HandFlat):
		if card_slot_found and !card_slot_found.card_in_slot:
			player_hand_reference.remove_card(card)
			card_slot_found.add_child(card)
			card.z_index = -1
			card.position = Vector2(50, 70)
			card.get_node("CardArea/CardCollision").disabled = true
			card_slot_found.card_in_slot = true
			is_hovering_on_card = false
	is_highlighting_a_card = false
	
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	if not get_window().mouse_exited.is_connected(on_hover_off_window):
		get_window().mouse_exited.connect(on_hover_off_window)
	if not get_window().mouse_entered.is_connected(on_hover_on_window):
		get_window().mouse_entered.connect(on_hover_on_window)
	
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
		last_hovered_card = card
		
func on_hovered_off_card(card):
	if card == last_hovered_card:
		var new_card_hovered = raycast_check_for_card()
		if card != new_card_hovered:
			highlight_card(card, false)
			if new_card_hovered:
				highlight_card(new_card_hovered, true)
				last_hovered_card = new_card_hovered
			else:
				is_hovering_on_card = false
				last_hovered_card = null

# window mouse event handlers
func on_hover_off_window():
	highlight_card(last_hovered_card, false)
	last_hovered_card = null

func on_hover_on_window():
	var resume_hover_card = raycast_check_for_card()
	if resume_hover_card:
		highlight_card(resume_hover_card, true)
		last_hovered_card = resume_hover_card
	
func highlight_card(card: Card, hovered: bool) -> void:
	if !card_being_dragged and card:
		if hovered:
			card.z_index = 1
			card.show_details(true)
			if is_instance_of(player_hand_reference, HandFlat):
				player_hand_reference.reposition_cards_flat_with_highlight(card)
				is_highlighting_a_card = true
		else:
			card.z_index = 0
			card.show_details(false)
			if is_instance_of(player_hand_reference, HandFlat):
				player_hand_reference.reposition_cards_flat()
				is_highlighting_a_card = false
