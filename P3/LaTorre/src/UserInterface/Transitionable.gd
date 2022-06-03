extends Control
class_name Transitionable

signal goto_next_scene(scene_name, use_menu_path)
signal goto_prev_scene(scene_name, use_menu_path)
signal toggle_configuration
signal exit_game

export (String) var next_scene = ""
export (String) var prev_scene = ""
