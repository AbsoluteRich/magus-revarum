extends MarginContainer

@onready var form: ButtonGroup = preload("res://scenes/forms.tres")
@onready var all_runes: Array[Node] = []

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
	if rune.button_group == form:
		spell_chain[0] = rune.text
	else:
		if spell_chain[0] == "":
			_display_dialog("Spell must start with a Form Rune!", rune)
			return

		if rune.text in spell_chain:
			spell_chain.remove_at(spell_chain.find(rune.text))
		else:
			if len(spell_chain) + 1 > rune_capacity:
				_display_dialog("Spell is at capacity! Remove a Rune to make space.", rune)
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
	%SpellChain.text = "Spell Chain: "
	%RuneCapacity.text = "0/" + str(rune_capacity)


# *------------*
# | Game logic |
# *------------*
func resolve() -> Array[int]:
	var result: Array[int] = [1, 0, 0]
	var target_self: bool = false
	var previous_rune: String = ""

	if spell_chain[0] == "":
		_reset()
		result[0] = 0
		return result

	for rune in spell_chain:
		match rune:
			"Self":
				target_self = true
			"Wound":
				if target_self:
					result[1] -= Global.rng.randi_range(10, 20)
				else:
					result[2] -= Global.rng.randi_range(10, 20)
			"Boost":
				if previous_rune == "Wound":
					# Double the damage of the attack
					result[2] -= Global.rng.randi_range(10, 20)

		previous_rune = rune

	_reset()
	print(result)
	return result
