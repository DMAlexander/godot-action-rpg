extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
		
func create_grass_effect():
	var grassEffect = load("res://Effects/GrassEffect.tscn").instantiate()
	grassEffect.global_position = global_position
	get_tree().current_scene.add_child(grassEffect)

#func create_grass_effect():
	#var grassEffect = GrassEffect.instance()
	#get_parent().add_child(grassEffect)
	#grassEffect.global_position = global_position
	#
#func _on_hurtbox_area_entered(area: Area2D) -> void:
	#create_grass_effect()
	#queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()
