extends Control
class_name Menu

signal quit_game

@export var button_container: Control

var buttons: Array[Button]

func _ready() -> void:
	pass

func connect_signals() -> void:
	pass
	
func init_menu() -> void:
	buttons = get_buttons()
	set_menu_data()
	connect_signals()
	
func get_buttons() -> Array[Button]:
	var buttons_list: Array[Button] = []
	
	if button_container == null:
		return buttons_list
	
	for i in button_container.get_children():
		if i.is_class("Button"):
			buttons_list.append(i)
			
	return buttons_list

func set_menu_data() -> void:
	pass
	
func new_game() -> void:
	SignalBus.new_game_signal.emit()
	
func quit() -> void:
	SignalBus.quit_game_signal.emit()
	
func signal_check(sig: Signal, function: StringName) -> void:
	if sig.is_connected(Callable(self, function)):
		print(str(sig) + " successfully connected to " + function)
	else:
		print(str(sig) + " failed to connect to " + function)
