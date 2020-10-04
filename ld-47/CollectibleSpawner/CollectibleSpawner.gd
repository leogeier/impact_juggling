extends Node2D

export(Vector2) var extent = Vector2(200, 200)
export var max_collectibles = 2
export var timer_min = 5
export var timer_max = 15
export(NodePath) var collectible_node_path

var main
var collectible_node
var current_collectible_count = 0
var Collectible = preload("res://Collectible/Collectible.tscn")

func spawn_collectible():
	var collectible = Collectible.instance()
	
	var offset = extent * Vector2(rand_range(-1, 1), rand_range(-1, 1))
	collectible.position = position + offset
	
	collectible.connect("collected", self, "on_collected")
	collectible.connect("not_collected", main, "remove_life")
	collectible_node.add_child(collectible)
	
	current_collectible_count += 1

func on_collected():
	current_collectible_count -= 1

func _ready():
	randomize()
	$SpawnTimer.connect("timeout", self, "spawn_collectible")
	collectible_node = get_node(collectible_node_path)
	main = get_tree().get_nodes_in_group("main")[0]

func _process(delta):
	if current_collectible_count < max_collectibles \
	   and $SpawnTimer.is_stopped():
		var wait_time = randi() % (timer_max - timer_min) + timer_min
		$SpawnTimer.start(wait_time)
