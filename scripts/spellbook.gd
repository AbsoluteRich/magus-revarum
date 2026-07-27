extends MarginContainer

@onready var form: ButtonGroup = preload("res://scenes/forms.tres")
# Nested type definitions aren't a feature yet, so I actually can't statically type this
@onready var all_runes := []

@export var rune_capacity: int = 6

var spell_chain: Array[String] = [""]


# *---------------------*
# | Lifestyle functions |
# *---------------------*
func _ready() -> void:
	all_runes.append_array(%FormRunes.get_children())
	all_runes.append_array(%ActionRunes.get_children())
	all_runes.append_array(%ModifierRunes.get_children())

	for rune in all_runes:
		rune.connect("pressed", _handle_rune.bind(rune))

	_reset()


# *------------------*
# | Signal callbacks |
# *------------------*
func _handle_rune(rune: Button) -> void:
	if len(spell_chain) + 1 > rune_capacity:
		_display_dialog("Spell is at capacity! Remove a Rune to make space.", rune)
		return

	if rune.button_group == form:
		spell_chain[0] = rune.text
	else:
		if spell_chain[0] == "":
			_display_dialog("Spell must start with a Form Rune!", rune)
			return

		if rune.text in spell_chain:
			spell_chain.remove_at(spell_chain.find(rune.text))
		else:
			spell_chain.append(rune.text)

	%SpellChain.text = "Spell Chain: " + " + ".join(spell_chain)
	%RuneCapacity.text = str(len(spell_chain)) + "/" + str(rune_capacity)


# *-----------------*
# | Private helpers |
# *-----------------*
func _display_dialog(message: String, to_cancel: Button) -> void:
	%CoreMessage.dialog_text = message
	%CoreMessage.popup_centered()
	to_cancel.button_pressed = not to_cancel.button_pressed


func _reset() -> void:
	for rune in all_runes:
		rune.button_pressed = false

	spell_chain = [""]
	%RuneCapacity.text = "0/" + str(rune_capacity)


# *------------*
# | Game logic |
# *------------*
func resolve(player_health: int, enemy_health: int) -> Array[int]:
	var success: int = 1
	var target_self = false

	if spell_chain[0] == "":
		success = 0
		_reset()
		return [success, player_health, enemy_health]

	for rune in spell_chain:
		match rune:
			"Self":
				target_self = true
			"Wound":
				if target_self:
					player_health -= Global.rng.randi_range(1, 5)
				else:
					enemy_health -= Global.rng.randi_range(1, 5)

	_reset()
	return [success, player_health, enemy_health]
