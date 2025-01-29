extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200
@export var WANDER_TARGET_RANGE = 4

enum { IDLE, WANDER, CHASE }

#var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

@onready var sprite = $AnimatedSprite
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = pick_random_state([IDLE, WANDER])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
#	knockback = move_and_slide(knockback)
	
	#match state:
		#IDLE:
			#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			#seek_player()
			#if wanderController.get_time_left() == 0:
				#update_wander()
		#WANDER:
			#seek_player()
			#if wanderController.get_time_left() == 0:
				#update_wander()
			#accelerate_towards_point(wanderController.target_position, delta)
			#if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				#update_wander()
		#CHASE:
			#var player = playerDetectionZone.player
			#if player != null:
				#accelerate_towards_point(player.global_position, delta)
			#else:
				#state = IDLE
				#
	#if softCollision.is_colliding():
		#velocity += softCollision.get_push_vector() * delta * 400
	#move_and_slide()
#	velocity = move_and_slide(velocity)
	

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(randf_range(1, 3))
	
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
func _on_Hurtbox_invincibility_start():
	animationPlayer.play("Start")
	
func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")


func _on_hurtbox_area_entered(area: Area2D) -> void:
#	stats.health -= 1
#	if stats.health <= 0:
#		queue_free()
#	velocity = area.knockback_vector * 120
#	queue_free()
	stats.health -= area.damage
	velocity = area.knockback_vector * 120


func _on_stats_no_health() -> void:
	queue_free()
