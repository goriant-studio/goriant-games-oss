extends Node

func layer(layer_index: int) -> int:
	return 1 << (layer_index - 1)
