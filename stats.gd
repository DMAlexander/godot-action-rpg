extends Node

@export var max_health = 3
@export var health: int:
	get:
		return max_health
	set(value):
		max_health = value

func _process(delta):
	if health <= 0:
		emit_signal("no_health")

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")

#@export(int) var max_health = 1 setget set_max_health
#var health = max_health setget set_health
#
#signal no_health
signal health_changed(value)
#signal max_health_changed(value)
#
#func set_max_health(value):
	#max_health = value
	#self.health = min(health, max_health)
	#emit_signal("max_health_changed", max_health)
	#
#func set_health(value):
	#health = value
	#emit_signal("health_changed", health)
	#if health <= 0:
		#emit_signal("no_health")
#
#func _ready() -> void:
	#self.health = max_health
