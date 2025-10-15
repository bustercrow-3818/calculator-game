extends Node2D
class_name Upgrade

@export var cost: float
@export var plain_text_name: String
@export_multiline var description: String

var keypad: Keypad
var target: Target
var clock: GameClock

func init_upgrade() -> void:
	pass

func connect_signals() -> void:
	pass

func purchased() -> void:
	SignalBus.purchase.emit(-cost)
