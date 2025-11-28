@tool
class_name Card extends Node2D

signal hovered
signal hovered_off

const HOVER_OFFSET := 30

@export var card_id: String = ""
@export var cost: int = 0
@export var card_name: String = "King"
@export var atk: int = 0
@export var hp: int = 0
@export var card_image: Node2D 

@onready var cost_lbl: Label = $FaceCard/CostNode/CostLbl
@onready var name_lbl: Label = $FaceCard/NameNode/NameLbl
@onready var atk_lbl: Label = $FaceCard/HBoxContainer/AtkLbl
@onready var hp_lbl: Label = $FaceCard/HBoxContainer/HpLbl
@onready var face: Node2D = $FaceCard
@onready var art: Sprite2D = $FaceCard/ArtCanvas/Art
@onready var default_face_pos: Vector2 = face.position

func _ready():
	get_parent().connect_card_signals(self)
	#cost_lbl.visible = true;
	cost_lbl.set_text(str(cost))
	name_lbl.set_text(card_name)
	atk_lbl.set_text(str(atk))
	hp_lbl.set_text(str(hp))
	
func _process(delta):
	_update_graphics_values()

func show_details(show: bool):
	if show:
		pass
	else:
		pass

func set_card_values(dict: Dictionary):
	cost = int(dict["cost"])
	card_name = dict["card_name"]
	atk = int(dict["atk"])
	hp = int(dict["hp"])
	
	_update_graphics_values()
	
func _update_graphics_values():
	cost_lbl.set_text(str(cost))
	name_lbl.set_text(card_name)
	atk_lbl.set_text(str(atk))
	hp_lbl.set_text(str(hp))
	
	


func _on_card_area_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_card_area_mouse_exited() -> void:
	emit_signal("hovered_off", self)
