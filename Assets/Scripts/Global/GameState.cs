public enum GameState
{
    OVERWORLD,   // normal gameplay
    ENCOUNTER_START,    // upon collision with enemy
    ENCOUNTER_MAIN,   // encounter main menu state
    ENCOUNTER_END,   // encounter end (despawn the enemy)
    /* Flirt states */
    ENCOUNTER_FLIRT,

    /* Flounder states */
    PRE_BATTLE,  // prepare battle state
    BATTLE_COUNTDOWN,   // fighting begins
    BATTLING,    // fight minigame
    BATTLE_END,    // fight minigame

    /* Miscellaneous states */
    PAUSED,      // paused state
    CUTSCENE,    // scene transitions, dialogue

    /* Boss fight states */
    BOSS_START, // upon collision with boss

    BOSS_MAIN, // transitions immediately into flirt
    POST_BOSS_START, // starts post boss dialogue
    POST_BOSS_DIALOGUE,
}
