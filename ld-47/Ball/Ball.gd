extends Node2D

export var gravity = 400
var velocity = Vector2()

func _ready():
	for paddle in get_tree().get_nodes_in_group("paddle"):
		paddle.add_ball(self)

func reflect(dir):
	velocity = velocity.length() * dir
	print(dir)

func _process(delta):
	velocity.y += gravity * delta
	position += velocity * delta
