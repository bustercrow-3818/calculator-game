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
	
	# Signal to deduct time for purchasing an upgrade
	SignalBus.purchase.connect(adjust_time)
	
	# Signal requesting remaining time
	SignalBus.time_request.connect(time_report)
	
func _process(_delta: float) -> void:
	disp.text = str(snapped(timer.get_time_left(), 0.1))

func add_time(new_game: bool = false) -> void:
	if new_game == true:
		return
	
	adjust_time(time_reward)
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

func adjust_time(qty: float) -> void:
	if -qty > timer.time_left:
		return
	
	var label = Label.new()
	var tween = create_tween()
	add_child(label)
	timer.start(timer.time_left + qty)
	label.position = disp.position + Vector2(disp.position.x * -3, 0)
	
	if qty < 0:
		label.text = str("-" + str(qty))
		label.modulate = Color(1,0,0,1)
		tween.tween_property(label, "modulate", Color(1,0,0,0), 1.5)
	else:
		label.text = str("+" + str(qty))
		label.modulate = Color(0,1,0,1)
		tween.tween_property(label, "modulate", Color(0,1,0,0), 1.5)
	await tween.finished
	label.queue_free()

func time_report() -> void:
	SignalBus.time_report.emit(timer.time_left)
