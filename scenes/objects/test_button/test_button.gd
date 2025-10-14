extends Node2D

@onready var button: Button = $Button

@export var power: int

func _ready() -> void:
	button.text = str(power * -1)
	button.connect("pressed", SignalBus.score_received.bind(power))
	pass
	
