extends Node

export(int) var level_attemps = 1

const PREV = 'previous'
const NEXT = 'next'

const GRAVITY = Vector2(0, 1200)
const UP = Vector2(0, -1)

const GROUP_TILES = "tiles"

const RAY_LEN = 8

func modulo(num, mod):
	return num - mod * floor(num / mod)