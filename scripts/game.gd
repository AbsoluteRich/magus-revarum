extends Control

@onready var timer: Timer = $Timer
@onready var bar_timer: ProgressBar = $Hud/BarTimer
@onready var player_health: ProgressBar = $Hud/BarHealth
@onready var enemy: VBoxContainer = $Enemy
@onready var enemy_health: ProgressBar = enemy.get_node("BarHealth")
@onready var spellbook: MarginContainer = $Spellbook
@onready var btn_cast: Button = $BtnCast

@export var initial_time: int = 60

var spellbook_open: bool = false


# *---------------------*
# | Lifestyle functions |
# *---------------------*
func _ready() -> void:
	timer.wait_time = initial_time
	bar_timer.max_value = initial_time

	timer.start()


func _process(_dt: float) -> void:
	bar_timer.value = timer.time_left

	if timer.time_left == 0 and player_health.get_health() > 0:
		player_health.update_health(Global.rng.randi_range(-5, -10))

		if player_health.get_health() <= 0:
			print("Game over!")
			await get_tree().create_timer(2.5).timeout
			get_tree().quit()
		else:
			timer.start()


# *------------------*
# | Signal callbacks |
# *------------------*
func _on_spellbook_opened() -> void:
	_element_visibility()


func _on_spell_cast() -> void:
	if timer.paused == false:
		timer.paused = true
		var result: Array[int] = spellbook.resolve()
		_element_visibility()

		if result[0]:
			player_health.update_health(result[1])
			enemy_health.update_health(result[2])

			await get_tree().create_timer(1).timeout

		timer.start()
		timer.paused = false


# *------------*
# | UI helpers |
# *------------*
func _element_visibility() -> void:
	spellbook_open = not spellbook_open
	spellbook.visible = spellbook_open
	btn_cast.disabled = not spellbook_open
	btn_cast.visible = spellbook_open
