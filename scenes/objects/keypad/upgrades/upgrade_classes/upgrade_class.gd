extends Node2D
class_name Upgrade

@export var plain_text_name: String
@export_multiline var description: String
@export var keypad: Keypad
@export var target: Target
@export var clock: GameClock

func init_upgrade() -> void:
	pass

func connect_signals() -> void:
	pass
