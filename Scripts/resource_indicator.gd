extends Control

@onready var sprite: AnimatedSprite2D = $sprite
@onready var txt: Label = $Node2D/txt

@export var value: int = 0
@export var resource_name: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	txt.text = str(value)

func setup(new_sprite_frames: SpriteFrames, name: String, amount: int):
	sprite.sprite_frames = new_sprite_frames
	sprite.play("default")
	self.value = amount
	self.resource_name = name
