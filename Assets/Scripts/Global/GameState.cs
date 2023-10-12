public enum GameState
{
    OVERWORLD,   // normal gameplay
    PRE_BATTLE,  // prepare battle state
    BATTLE_COUNTDOWN,   // fighting begins
    BATTLING,    // fight minigame
    BATTLE_END,    // fight minigame
    PAUSED,      // paused state
    CUTSCENE,    // scene transitions, dialogue
}
