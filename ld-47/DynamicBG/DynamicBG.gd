extends Node2D

# Code duplication? What's code duplication?

export var wobble_speed = 0.0007
export var wobble_strength = 2
export var time_offset_cap = 100
export var life_lost_offset = -45
export var life_lost_anim_dur = .8

var light_y
var goal_light_y
var dark_y
var goal_dark_y
var light_time_offset = 0
var dark_time_offset = 0

func on_life_lost():
	goal_light_y = goal_light_y + life_lost_offset - 10
	$LightTween.interpolate_property(self, "light_y", light_y, goal_light_y, life_lost_anim_dur, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$LightTween.start()
	goal_dark_y = goal_dark_y + life_lost_offset
	$DarkTween.interpolate_property(self, "dark_y", dark_y, goal_dark_y, life_lost_anim_dur, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$DarkTween.start()

func on_game_over():
	$LightTween.interpolate_property(self, "light_y", light_y, 55, life_lost_anim_dur, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$LightTween.start()
	$DarkTween.interpolate_property(self, "dark_y", dark_y, 155, life_lost_anim_dur, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$DarkTween.start()

func _ready():
	randomize()
	light_y = $Light.position.y
	goal_light_y = light_y
	dark_y = $Dark.position.y
	goal_dark_y = dark_y

func _process(delta):
	var time = OS.get_ticks_msec()
	light_time_offset += randi() % time_offset_cap
	dark_time_offset += randi() % time_offset_cap
	
	$Light.position.y = light_y + sin((time + light_time_offset) * wobble_speed) * wobble_strength
	$Dark.position.y = dark_y + sin((time + dark_time_offset) * wobble_speed) * wobble_strength
