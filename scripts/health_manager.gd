extends ProgressBar

@onready var bar: ProgressBar = self
@onready var label: Label = self.get_node("LblHealth")

@export var max_health: int
var _health: int = max_health


func _ready() -> void:
	bar.max_value = max_health
	set_health(max_health)


func get_health() -> int:
	return _health


func set_health(new_health: int):
	_health = new_health
	bar.value = new_health
	label.text = str(_health) + "/" + str(max_health)


func update_health(modifier: int):
	_health = get_health()
	_health += modifier
	set_health(_health)
