public enum GameState
{
    OVERWORLD_PLAYING,  // normal gameplay
    OVERWORLD_PAUSED,   // paused by player
    PRE_FIGHT,          // prepare battle state
    FIGHT_PLAYING,      // fight minigame
    FIGHT_PAUSED,       // fight minigame, paused - may not implement this?
    CUTSCENE,   // scene transitions, dialogue
}
