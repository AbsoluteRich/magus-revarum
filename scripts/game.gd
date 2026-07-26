extends Control

@onready var timer: Timer = $Timer
@onready var timer_bar: ProgressBar = $Hud/BarTimer
@onready var health_bar: ProgressBar = $Hud/BarHealth
@onready var enemy: VBoxContainer = $Enemy
@onready var spellbook: MarginContainer = $Spellbook
@onready var spell_chain_container: HBoxContainer = spellbook.get_node("Panel/Runes")
@onready var form: ButtonGroup = preload("res://scenes/forms.tres")
@onready var btn_cast: Button = $BtnCast

var initial_time: float = 10
var spellbook_open: bool = false
var spell_chain: Array[String] = [""]


# *---------------------*
# | Lifestyle functions |
# *---------------------*
func _ready() -> void:
	timer.wait_time = initial_time
	timer_bar.max_value = initial_time
	timer.start()

	for element in spell_chain_container.get_children():
		element.connect("pressed", handle_rune.bind(element))

	element_visibility()


func _process(_dt: float) -> void:
	timer_bar.value = timer.time_left

	if timer.time_left == 0:
		health_bar.value -= 50

		if health_bar.value <= 0:
			print("Game over!")
			await get_tree().create_timer(2.5).timeout
			get_tree().quit()
		else:
			timer.start()


# *--------------*
# | GUI bindings |
# *--------------*
func _on_spellbook_opened() -> void:
	spellbook_open = not spellbook_open
	element_visibility()


func _on_spell_cast() -> void:
	# Placeholder until spell mechanics are implemented
	enemy.update_health(-5)


func handle_rune(rune: Button) -> void:
	if rune.button_group == form:
		spell_chain[0] = rune.text
	else:
		if rune.text in spell_chain:
			spell_chain.remove_at(spell_chain.find(rune.text))
		else:
			spell_chain.append(rune.text)
	print(spell_chain)


# *------------*
# | Game logic |
# *------------*
func element_visibility() -> void:
	spellbook.visible = spellbook_open
	btn_cast.disabled = not spellbook_open
	btn_cast.visible = spellbook_open
