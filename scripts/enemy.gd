extends VBoxContainer

@onready var health_bar: ProgressBar = $HealthBar

@export var max_health: float = 100
@export var health: float = 0


func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = max_health


func get_health() -> float:
	return health_bar.value


func set_health(new_health: float):
	health = new_health
	health_bar.value = new_health


func update_health(modifier: float):
	health = get_health()
	health += modifier
	set_health(health)
