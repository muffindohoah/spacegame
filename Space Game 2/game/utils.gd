extends Node

signal NodeSelected (node, isStaging : bool)
signal WebChanged ()

var Suppliers = []
var Demanders = []

var NodeDB = {
	"Relay":{"PackedScene":preload("res://nodes/relay.tscn"), "Price":1, "PowerToBuild":2, "ConnectionRange":100},
	"Generator":{"PackedScene":preload("res://nodes/gen.tscn"), "Price":10, "PowerToBuild":15, "ConnectionRange":100},
	"Turret":{"PackedScene":preload("res://nodes/turret.tscn"), "Price":7, "PowerToBuild":7, "ConnectionRange":60},
	"Miner":{"PackedScene":null, "Price":4, "PowerToBuild":4, "ConnectionRange":60}
	}

var SelectedNode = null
