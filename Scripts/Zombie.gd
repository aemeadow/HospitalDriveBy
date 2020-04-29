extends RigidBody2D

export var limit_y = 350
export var score = 100
export var damage = 10
export var speed = 0.5
export var move_probability = 0.10

var ready = false
onready var Player = get_node("/root/Game/Ship")
var new_position = Vector2(0,0)

func get_new_position():
	var VP = get_viewport_rect().size
	new_position.x = randi() % int(VP.x)
	new_position.y = min(randi() % int(VP.y), int(VP.y) - limit_y)
	$Tween.interpolate_property(self, "position", position, new_position, speed, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	ready = true

func die():
	queue_free()

func _ready():
	randomize()
	get_new_position()
	contact_monitor = true
	set_max_contacts_reported(4)


func _physics_process(delta):
	if ready:
		$Tween.start()
		ready = false
	var colliding = get_colliding_bodies()
	for c in colliding:
		if c.name == "Ship":
			Player.change_health(-damage)
		queue_free()

	if position.y > get_viewport_rect().size.y + 10:
		queue_free()

func _integrate_forces(state):
	state.set_linear_velocity(Vector2(0,speed))
	state.set_angular_velocity(0)


func _on_Timer_timeout():
	if randf() < move_probability:
		get_new_position()