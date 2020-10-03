extends Node2D

export(Vector2) var extent = Vector2(200, 200)
export var max_collectibles = 2
export var timer_min = 5
export var timer_max = 15

var current_collectible_count = 0
var Collectible = preload("res://Collectible/Collectible.tscn")

func spawn_collectible():
	var collectible = Collectible.instance()
	
	var offset = extent * Vector2(rand_range(-1, 1), rand_range(-1, 1))
	collectible.position = position + offset
	print("spawned col at", collectible.position)
	
	collectible.connect("collected", self, "on_collected")
	get_tree().get_root().add_child(collectible)
	
	current_collectible_count += 1

func on_collected():
	current_collectible_count -= 1

func _ready():
	randomize()
	$SpawnTimer.connect("timeout", self, "spawn_collectible")

func _process(delta):
	if current_collectible_count < max_collectibles \
	   and $SpawnTimer.is_stopped():
		var wait_time = randi() % (timer_max - timer_min) + timer_min
		$SpawnTimer.start(wait_time)
		print("spawning ocl in ", wait_time)