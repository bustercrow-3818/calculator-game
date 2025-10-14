extends Node2D

@export var menu_manager: MenuManager

@export var target: Node2D
@export var game_area: Node2D
@export var game_timer: Control
@export var keypad: Control

@export var difficulty: int ## Number of wins needed to increase difficulty. Higher number is easier.

@onready var debug: Button = $debug_button


func _physics_process(_delta: float) -> void:
	pass

func _ready() -> void:
	SignalBus.game_over.connect(show_game_over)
	SignalBus.quit_game_signal.connect(exit_game)
	SignalBus.new_game_signal.connect(new_game)
	SignalBus.checkpoint_signal.connect(enter_checkpoint)
	SignalBus.checkpoint_exit_signal.connect(exit_checkpoint)
	debug.pressed.connect(SignalBus.relay_signal.bind("debug"))
	
	target.difficulty = difficulty

func new_game() -> void:
	target.game_start()
	game_timer.game_start()
	keypad.game_start()
	menu_manager.menu_fadeout()
	game_area.show()
	
func show_game_over() -> void:
	game_area.hide()
	game_timer.hide()
	menu_manager.show_menu("game_over")
	
func exit_game() -> void:
	get_tree().quit()

func difficulty_increase() -> void:
	target.difficulty_increase()
	keypad.difficulty_increase()
	
	if target.level > 4:
		keypad.disable_operators(keypad.get_random_operators(1))
	
func enter_checkpoint() -> void:
	var tween = create_tween()
	game_timer.stop()
	tween.tween_property(game_area, "modulate", Color(1,1,1,0), 0.25)
	await tween.finished
	game_area.hide()
	menu_manager.enter_checkpoint()
	

func show_game_area() -> void:
	var tween = create_tween()
	menu_manager.menu_fadeout()
	
	game_area.show()
	tween.tween_property(game_area, "modulate", Color(1,1,1,1), 0.5)

func exit_checkpoint() -> void:
	menu_manager.exit_checkpoint()
	difficulty_increase()
	
	show_game_area()
