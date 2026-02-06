class_name IBuild
extends Node2D

@export var build_name: String
@export var level: int
@export var health: int
@export var cost: int

@onready var select: Button = $Select

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_selected_build() -> void:
	if (level < 7):
		level += 1
	pass
