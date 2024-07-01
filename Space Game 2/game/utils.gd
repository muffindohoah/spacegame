extends Node

signal NodeSelected (node, isStaging : bool)

var Suppliers = []
var Demanders = []

var NodeDB = {
	"Generator":{"Price":10, "PowerToBuild":15, "ConnectionRange":100},
	"Turret":{"Price":7, "PowerToBuild":7, "ConnectionRange":60},
	"Miner":{"Price":4, "PowerToBuild":4, "ConnectionRange":60}
	}

var SelectedNode = null
