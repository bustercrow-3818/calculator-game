extends Menu

@onready var final_score: Label = $final_score
@onready var new_game_button: Button = $VBoxContainer/new_game
@onready var quit_button: Button = $VBoxContainer/quit

func connect_signals() -> void:
	new_game_button.pressed.connect(new_game)
	quit_button.pressed.connect(quit)
	SignalBus.system_score_update.connect(update_final_score)

func update_final_score(score: float = 0) -> void:
	final_score.text = "Final score: " + str(score)
