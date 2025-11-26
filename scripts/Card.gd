@tool
class_name Card extends Node2D

signal hovered
signal hovered_off

@export var cost: int = 0
@export var card_name: String = "King"
@export var atk: int = 0
@export var hp: int = 0
@export var card_image: Node2D 

@onready var cost_lbl: Label = $CostNode/CostLbl
@onready var name_lbl: Label = $NameNode/NameLbl
@onready var atk_lbl: Label = $HBoxContainer/AtkLbl
@onready var hp_lbl: Label = $HBoxContainer/HpLbl

func _ready():
	get_parent().connect_card_signals(self)
	cost_lbl.visible = false;
	cost_lbl.set_text(str(cost))
	name_lbl.set_text(card_name)
	atk_lbl.set_text(str(atk))
	hp_lbl.set_text(str(hp))
	
func _process(delta):
	_update_graphics_values()

func show_details(show: bool):
	if show:
		cost_lbl.visible = true
	else:
		cost_lbl.visible = false	

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
