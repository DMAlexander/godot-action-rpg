extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")
@onready var timer: Timer = $Timer

@export var set_invincible = false
@export var invincible: bool:
	get:
		return set_invincible
	set(value):
		set_invincible = value

signal invincibility_started
signal invincibility_ended

func set_invincible_func(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_started")
		
		
func start_invincibility(duration):
	self.invincibile = true
	timer.start(duration)

func create_hit_effect(area: Area2D) -> void:
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

#
#const HitEffect = preload("res://Effects/HitEffect.tscn")
#
#var invincible = false setget set_invincible
#
#@onready var timer = $Timer
#@onready var collisionShape = $CollisionShape2D
#
#signal invincibility_started
#signal invincibility_ended
#
#func set_invincible(value):
	#invincible = value
	#if invincible == true:
		#emit_signal("invincibility_started")
	#else:
		#emit_signal("invincibility_ended")
		#
#func start_invincibility(duration):
	#self.invincible = true
	#timer.start(duration)
	#
#func create_hit_effect():
	#var effect = HitEffect.instance()
	#var main = get_tree().current_scene
	#main.add_child(effect)
	#effect.global_position = global_position
	#
#func _on_Timer_timeout():
	#self.invincible = false
	#
#func _on_Hurtbox_invincibility_started():
	#collisionShape.set_deferred("disabled", true)
	#
#func _on_Hurtbox_invincibility_ended():
	#collisionShape.disabled = false


func _on_invincibility_started() -> void:
	set_deferred ("monitoring", false)


func _on_invincibility_ended() -> void:
	monitoring = true
	


func _on_timer_timeout() -> void:
	self.invincible = false
