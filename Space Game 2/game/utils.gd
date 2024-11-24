extends Node

@onready var NodeDB = {
	"relay":getNodeTypeData("relay"),
	"generator":getNodeTypeData("gen"),
	"turret":getNodeTypeData("turret"),
	"miner":getNodeTypeData("miner")
	#"battery":getNodeTypeData("Battery")
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

func getNodeTypeData(nodeType):
	print(("res://nodes/{n}/{n}.tres").format({"n": str(nodeType)}))
	var typeData := load(("res://nodes/{n}/{n}.tres").format({"n": str(nodeType)})) as nodeDB
	return typeData
