extends Node

var NodeDB = {
	"Relay":{"PackedScene":preload("res://nodes/relay/relay.tscn"), "Price":1, "PowerToBuild":2, "ConnectionRange":100},
	"Generator":{"PackedScene":preload("res://nodes/generator/gen.tscn"), "Price":10, "PowerToBuild":15, "ConnectionRange":100},
	"Turret":{"PackedScene":preload("res://nodes/turret/turret.tscn"), "Price":7, "PowerToBuild":7, "ConnectionRange":60},
	"Miner":{"PackedScene":preload("res://nodes/miner/miner.tscn"), "Price":4, "PowerToBuild":4, "ConnectionRange":40},
	"Battery":{"PackedScene":preload("res://nodes/battery/battery.tscn"), "Price":6, "PowerToBuild":5, "ConnectionRange":60}
	}

var Suppliers = []
var Demanders = []

signal NodeSelected (node, isStaging : bool)
signal WebChanged()
signal ScoreChanged()

var SpaceRocks = 20 : set = SpaceRocksSet
var SelectedNode = null

func SpaceRocksSet(value):
	SpaceRocks = value
	ScoreChanged.emit()
