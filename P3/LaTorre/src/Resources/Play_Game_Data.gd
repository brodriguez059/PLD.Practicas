extends Resource
class_name Play_Game_Data

enum enum_play_difficulty {easy, medium, hard}
enum enum_play_mode {singleplayer, multiplayer}

export(enum_play_mode) var play_mode = enum_play_difficulty.easy
export(enum_play_difficulty) var play_difficulty = enum_play_mode.singleplayer

export(String) var player1_character_class = ""
export(String) var player2_character_class = ""
