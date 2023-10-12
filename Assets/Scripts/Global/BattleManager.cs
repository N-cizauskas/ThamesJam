using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class BattleManager : MonoBehaviour
{
    // Singleton
    public static BattleManager Instance { get; private set; }

    /* Battle explanation: 
     * The 'battle leverage' defines the player's advantage in the battle. At 100, they win; at 0, they lose.
     * The player has a 'tug gauge'; there are two marked ranges in the gauge, green (normal) and yellow (crit), 
     * with the latter inside the former. The green range is static; the yellow range is random and only appears once the tug starts.
     * As the player holds a button, their tug gauge increases. 
     * When the player releases the button, if the position of the tug gauge is within the green 'tug range', battle leverage increases.
     * If the player releases the button within the yellow range, battle leverage increases even more.
     * The enemy will be doing something similar to decrease player leverage.
    **/

    // Constants
    // NOTE: Tug ranges are defined out of 100 for full bar width. This makes it flexible enough to apply to a bar of any width
    public static readonly int BASE_BATTLE_LEVERAGE = 50;       // the default position at battle start. maybe tune this to make it easier/harder?

    private static readonly int TUG_BASE_RANGE = 20;            // base width of the tug bar
    private static readonly int TUG_BASE_CRIT_RANGE = 5;        // base width of the crit bar
    private static readonly int TUG_FINESSE_NORM_MODIFIER = 3;  // how much each point of finesse widens the normal tug bar
    private static readonly int TUG_FINESSE_CRIT_MODIFIER = 1;  // how much each point of finesse widens the crit tug bar

    private static readonly int TUG_BASE_SPEED = 40;            // base increase in the tug gauge per second
    private static readonly int TUG_DEXTERITY_MODIFIER = 10;     // how much each point of dexterity increases gauge speed

    private static readonly int TUG_BASE_STRENGTH = 10;         // base increase in leverage on a successful tug
    private static readonly int TUG_STRENGTH_MODIFIER = 5;      // how much each point of strength increases leverage on a successful tug

    private static readonly float CRIT_MULTIPLIER = 1.5f;       // how much a 'critical' tug (yellow zone) affects leverage increase

    [field: Header("Battle State (values are only for visibility; changing them does nothing!)")]
    [field: SerializeField] public bool battleOngoing { get; private set; }     // if the battle is happening at the moment (if false, then still on the 'get ready' screen or ended)
    [field: SerializeField] public int battleLeverage { get; private set; }     // 0 - 100. see battle explanation above
    [field: SerializeField] public float playerTugValue { get; private set; }   // 0 - 100. the player's current position on the tug gauge
    [field: SerializeField] public int playerTugRangeMin { get; private set; }  // 0 - 100. tug range on the tug gauge (this should stay static)
    [field: SerializeField] public int playerTugRangeMax { get; private set; }
    [field: SerializeField] public int playerTugCritRangeMin { get; private set; }  // 0 - 100. critical tug range on the tug range (this should jump around)
    [field: SerializeField] public int playerTugCritRangeMax { get; private set; }
    [field: SerializeField] public bool playerTugging { get; private set; }         // for the UI to hide the critical range

    public bool IsBattleLeverageAtThreshold
    {
        get {
            // TODO: As sai pointed out, maybe we want to prevent battles lasting forever, so we could consider narrowing this threshold as well
            // A visual indicator to go with this would be nice
            return battleLeverage <= 0 || battleLeverage >= 100;
        }
    }

    // NOTE: these should NOT be where the player's stats are held! they should be on the player itself.
    // we keep track of them here separately to prevent them from changing mid-battle, and allow potential temporary modifiers to base stats if required.
    [Header("Player Stats")]
    [SerializeField] private int playerStrength;    // affects how much each successful tug increases the player's leverage
    [SerializeField] private int playerDexterity;   // affects how quickly the bar rises
    [SerializeField] private int playerFinesse;     // affects how wide the tug zones are - both normal and crit

    [Header("Enemy Stats")]
    [SerializeField] private int enemyDifficulty;   // TODO: placeholder; some value or values that determine battle difficulty

    void Awake()
    {
        if (Instance != null)
        {
            Debug.LogError("More than one BattleManager should not exist - it is a singleton");
        }
        Instance = this;
    }

    void Start()
    {
        GameStateManager.RegisterPauseHandler(OnPause);
        GameStateManager.RegisterUnpauseHandler(OnUnpause);
        GameStateManager.RegisterStartBattleHandler(OnStartBattle);
        GameStateManager.RegisterEndBattleHandler(OnEndBattle);

        UpdatePlayerTugRange();
        UpdatePlayerCritPosition();
    }

    void Update()
    {
        if (!battleOngoing) return;

        if (Input.GetButton("Submit") && GameStateManager.Instance.GameState == GameState.FIGHT_PLAYING)
        {
            if (!playerTugging) // if this is the first frame of the pull
            {
                // TODO: broadcast an event - to play sound from AudioManager, UI effect from UIManager, etc.
                UpdatePlayerCritPosition();
            }

            playerTugging = true;

            int playerTugSpeed = TUG_BASE_SPEED + (TUG_DEXTERITY_MODIFIER * playerDexterity);
            playerTugValue += Time.deltaTime * playerTugSpeed;
        }
        else
        {
            // release - check gauge state
            UpdateLeveragePlayerTug();
            playerTugging = false;
            playerTugValue = 0;
        }

        // At any point if the leverage value hits the threshold, battle manager will update state and broadcast the EndBattle event
    }

    void OnStartBattle(object sender, EventArgs e)
    {
        battleLeverage = 50;
        playerTugValue = 0;
        UpdatePlayerTugRange();

        battleOngoing = true;
    }

    void OnEndBattle(object sender, EventArgs e)
    {
        battleOngoing = false;
    }

    void OnPause(object sender, EventArgs e)
    {
        // TODO: something that pauses battle - maybe not necessary
    }

    void OnUnpause(object sender, EventArgs e)
    {
        // TODO: something that unpauses battle - maybe not necessary
    }

    private void UpdatePlayerTugRange()
    {
        int tugWidth = TUG_BASE_RANGE + (TUG_FINESSE_NORM_MODIFIER * playerFinesse);

        // TODO: maybe update this? for now i'm always going to set the max of the range at 100
        playerTugRangeMin = 100 - tugWidth;
        playerTugRangeMax = 100;
    }

    private void UpdatePlayerCritPosition()
    {
        int critWidth = TUG_BASE_CRIT_RANGE + (TUG_FINESSE_CRIT_MODIFIER * playerFinesse);

        // min is inclusive, max is exclusive
        playerTugCritRangeMin = UnityEngine.Random.Range(playerTugRangeMin, playerTugRangeMax - critWidth + 1);
        playerTugCritRangeMax = playerTugCritRangeMin + critWidth;
    }

    private void UpdateLeveragePlayerTug()
    {
        int leverageIncreaseOnPull = TUG_BASE_STRENGTH + (TUG_STRENGTH_MODIFIER * playerStrength);
        int leverageIncreaseOnCrit = Mathf.RoundToInt(leverageIncreaseOnPull * CRIT_MULTIPLIER);

        if (playerTugCritRangeMin <= playerTugValue && playerTugValue <= playerTugCritRangeMax)
        {
            Debug.Log("Crit!");
            battleLeverage += leverageIncreaseOnCrit;
        }
        else if (playerTugRangeMin <= playerTugValue && playerTugValue <= playerTugRangeMax)
        {
            Debug.Log("Pull");
            battleLeverage += leverageIncreaseOnPull;
        }
        else
        {
            // TODO: broadcast event on failed tug for UI/sound changes - and maybe add a cooldown?
        }
    }
}
