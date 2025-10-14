extends Control
class_name GameClock

@onready var timer: Timer = $Timer
@onready var disp = $Label

@export var bonus_time: float
@export var starting_timer: float

var time_reward: float = 5.0

func _ready() -> void:
	# Signal from target to add time to the clock
	SignalBus.next_level.connect(add_time)
	
	#Signal from keypad to deduct time from reward
	SignalBus.operation_begun.connect(operation_penalty)
	
	# Signal emitted to notify game that time has run out
	timer.timeout.connect(SignalBus.end_game)
	
	# Signal from checkpoint to continue the game
	SignalBus.checkpoint_exit_signal.connect(start)
	
func _process(_delta: float) -> void:
	disp.text = str(snapped(timer.get_time_left(), 0.1))

func add_time(new_game: bool = false) -> void:
	if new_game == true:
		return
	else:
		timer.start(timer.time_left + time_reward)
		time_reward = bonus_time

func game_start() -> void:
	timer.stop()
	timer.wait_time = starting_timer
	self.show()
	timer.start()

func operation_penalty() -> void:
	time_reward -= 1.0

func set_time_reward(qty: float) -> void:
	time_reward += qty
	
func stop() -> void:
	timer.paused = true
	
func start() -> void:
	timer.paused = false
