extends Menu

@onready var new_game_button: Button = $VBoxContainer/new_game
@onready var settings_button: Button = $VBoxContainer/settings
@onready var quit_button: Button = $VBoxContainer/quit

func _ready() -> void:
	
	pass

func connect_signals() -> void:
	new_game_button.pressed.connect(new_game)
	quit_button.pressed.connect(quit)

func settings() -> void:
	pass
