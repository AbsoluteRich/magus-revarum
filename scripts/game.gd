extends Control

@onready var timer: Timer = $TurnTimer
@onready var timer_bar: ProgressBar = $VBoxContainer/TimerBar
@onready var enemy: VBoxContainer = $Enemy

var initial_time: float = 5
var spell_chain: Array[String] = []


func _ready() -> void:
	timer.wait_time = initial_time
	timer_bar.max_value = initial_time
	timer.start()


func _process(_dt: float) -> void:
	timer_bar.value = timer.time_left
	if timer.time_left == 0:
		get_tree().quit()


func _on_attack_pressed() -> void:
	enemy.update_health(-5)
