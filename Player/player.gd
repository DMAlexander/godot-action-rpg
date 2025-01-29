extends CharacterBody2D

const ACCELERATION = 500
const MAX_SPEED: int = 80
const ROLL_SPEED = 125
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animationState = animation_tree.get("parameters/playback")
@onready var sword_hitbox: Area2D = $HitboxPivot/SwordHitbox

func _ready():
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_collide(velocity * delta)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state(_delta):
	animationState.travel("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/2 * _delta)
	move_and_slide()
	
func roll_state(_delta):
	animationState.travel("Roll")
	velocity = roll_vector * ROLL_SPEED
	move_and_slide()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if state == ROLL:
		velocity = velocity * 0.8
	state = MOVE


#
#const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
#
#@export var ACCELERATION = 500
#@export var MAX_SPEED = 80
#@export var ROLL_SPEED = 120
#@export var FRICTION = 500
#
#enum {
	#MOVE,
	#ROLL,
	#ATTACK
#}
#
#var state = MOVE
#var velocity = Vector2.ZERO
#var roll_vector = Vector2.DOWN
#var stats = PlayerStats
#
#@onready var animationPlayer = $AnimationPlayer
#@onready var animationTree = $AnimationTree
#@onready var animationState = animationTree.get("parameters/playback")
#@onready var swordHitbox = $HitboxPivot/SwordHitbox
#@onready var hurtbox = $Hurtbox
#@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
#
#func _ready() -> void:
	#randomize()
	#stats.connect("no_health", self, "queue_free")
	#animationTree.active = true
	#swordHitbox.knockbox_vector = roll_vector
	#
#func _physics_process(delta):
	#match state:
		#MOVE:
			#move_state(delta)
			#
		#ROLL:
			#roll_state()
			#
		#ATTACK:
			#attack_state()
			#
#func move_state(delta):
	#var input_vector = Vector2.ZERO
	#input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector.y = Input.get_action_strength("ui-down") - Input.get_action_strength("ui_up")
	#input_vector = input_vector.normalized()
	#
	#if input_vector != Vector2.ZERO:
		#roll_vector = input_vector
		#swordHitbox.knockback_vector = input_vector
		#animationTree.set("parameters/Idle/blend_position", input_vector)
		#animationTree.set("parameters/Run/blend_position", input_vector)
		#animationTree.set("parameters/Attack/blend_position", input_vector)
		#animationTree.set("parameters/Roll/blend_position", input_vector)
		#animationState.travel("Run")
		#velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	#else:
		#animationState.travel("Idle")
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		#
	#move()
	#
	#if Input.is_action_just_pressed("roll"):
		#state = ROLL
		#
	#if Input.is_action_just_pressed("attack"):
		#state = ATTACK
		#
#func roll_state():
	#velocity = roll_vector * ROLL_SPEED
	#animationState.travel("Roll")
	#move()
	#
#func attack_state():
	#velocity = Vector2.ZERO
	#animationState.travel("Attack")
	#
#func move():
	#pass
##	velocity = move_and_slide(velocity)
	#
#func roll_animation_finished():
	#velocity = velocity * 0.8
	#state = MOVE
	#
#func attack_animation_finished():
	#state = MOVE
	#
#func _on_Hurtbox_area_entered(area):
	#stats.health -= area.damage
	#hurtbox.start_invincibility(0.6)
	#hurtbox.create_hit_effect()
	#var player_HurtSound = PlayerHurtSound.instance()
	#get_tree().current_scene.add_child(PlayerHurtSound)
	#
#func _on_Hurtbox_invincibility_started():
	#blinkAnimationPlayer.play("Start")
	#
#func _on_Hurtbox_invincibility_ended():
	#blinkAnimationPlayer.play("Stop")
