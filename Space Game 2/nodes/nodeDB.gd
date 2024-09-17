extends Resource
class_name nodeDB

@export var nodeName = ""
@export var packedScene = preload("res://nodes/relay/relay.tscn")

@export var Price = 0
@export var PowerToBuild = 0
@export var ConnectionRange = 100

var Power = 0
@export var PowerThreshold = 20
@export var displayedValues = []
