extends Node

@warning_ignore("unused_signal")
signal system_score_update(score: float)
signal score(qty: int)
signal next_level(new_game: bool)
signal game_over
signal new_game_signal
signal difficulty_increase
signal operation_begun
signal quit_game_signal
signal checkpoint_signal
signal checkpoint_exit_signal
signal debug
signal pick_upgrade(upgrade: Upgrade, button: Button)

func score_received(qty: int) -> void:
	score.emit(qty)

func end_game() -> void:
	game_over.emit()

func relay_next_level(new_game: bool) -> void:
	next_level.emit(new_game)

func relay_checkpoint_signal() -> void:
	checkpoint_signal.emit()
	
func relay_signal(signal_name: String) -> void:
	emit_signal(signal_name)

func upgrade(new_upgrade: Upgrade, button: Button) -> void:
	pick_upgrade.emit(new_upgrade, button)
