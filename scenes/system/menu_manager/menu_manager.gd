extends Control
class_name MenuManager

var menus: Dictionary = {}

@onready var current_menu: Menu = $main_menu

func _ready() -> void:
	menus = get_menus()
	for i in get_children():
		if i.has_method("init_menu"):
			i.init_menu()

func show_menu(menu: String) -> void: ## Display a menu by name
	#menu_fadeout()
	
	var tween = create_tween()
	
	tween.tween_property(menus[menu], "modulate", Color(1,1,1,1), 1.5)
	menus[menu].show()
	current_menu = menus[menu]

func get_menus() -> Dictionary:
	var menu_dict: Dictionary
	
	for i in get_children():
		menu_dict[i.name] = i
		
	return menu_dict

func menu_fadeout(menu:Menu = current_menu) -> void:
	var tween = create_tween()
	
	tween.tween_property(menu, "modulate", Color(1,1,1,0), 0.25)
	await tween.finished
	menu.hide()

func enter_checkpoint() -> void:
	SignalBus.time_request.emit()
	menus["checkpoint"].set_current_options()
	show_menu("checkpoint")
	menus["checkpoint"].breath_pulse(true)

func exit_checkpoint() -> void:
	menus["checkpoint"].clear_options()
