extends Node

var TILE_WIDTH = 928
var tiles
var player

func _ready():
	tiles = [get_node("Tile1"), get_node("Tile2"), get_node("Tile3")]
	player = get_node("../Player")

func _process(delta):
	var player_x = player.transform.origin.x
	var tile_x = tiles[1].transform.origin.x
	
	if player_x > (tile_x + TILE_WIDTH/2):
		var swap = tiles[0]
		swap.reset_positions()
		swap.transform.origin = Vector2(tiles[2].transform.origin.x + TILE_WIDTH, swap.transform.origin.y)
		tiles[0] = tiles[1]
		tiles[1] = tiles[2] 
		tiles[2] = swap
		
	if player_x < (tile_x - TILE_WIDTH/2):
		var swap = tiles[2]
		swap.reset_positions()
		swap.transform.origin = Vector2(tiles[0].transform.origin.x - TILE_WIDTH, swap.transform.origin.y)
		tiles[2] = tiles[1]
		tiles[1] = tiles[0]
		tiles[0] = swap
	