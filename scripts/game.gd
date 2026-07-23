extends Control

@onready var timer: Timer = $TurnTimer
@onready var timer_bar: ProgressBar = $Hud/TimerBar
@onready var enemy: VBoxContainer = $Enemy
@onready var spell_chain_container: HBoxContainer = $SpellChain
@onready var form: ButtonGroup = preload("res://scenes/forms.tres")

var initial_time: float = 5
var spell_chain: Array[String] = [""]


func _ready() -> void:
	timer.wait_time = initial_time
	timer_bar.max_value = initial_time
	timer.start()
	
	for element in spell_chain_container.get_children():
		element.connect("pressed", handle_rune.bind(element))



func _process(_dt: float) -> void:
	timer_bar.value = timer.time_left
	if timer.time_left == 0:
		get_tree().quit()


func _on_attack_pressed() -> void:
	enemy.update_health(-5)


func handle_rune(rune: Button):
	if rune.button_group == form:
		spell_chain[0] = rune.text
	else:
		if rune.text in spell_chain:
			spell_chain.remove_at(spell_chain.find(rune.text))
		else:
			spell_chain.append(rune.text)
	print(spell_chain)
