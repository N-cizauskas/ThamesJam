using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GameStateManager : MonoBehaviour
{
    // values set in editor
    [Tooltip("Pause the game on losing focus - disable for easier debugging.")]
    public bool PauseOnFocusLoss = false;
    [Tooltip("Player GameObject - used to keep track of collisions with enemies.")]

    // Singleton
    public static GameStateManager Instance { get; private set; }

    /* Constants */
    public static readonly float ENCOUNTER_DELAY_SECONDS = 1.5f;
    public static readonly float BATTLE_COUNTDOWN_PERIOD_SECONDS = 3f;
    private static readonly GameState[] PAUSED_GAME_STATES = {GameState.PAUSED};

    public static bool canTurn = true;


    /* Game State Variables */
    // pausing
    public GameState GameState { get; private set; }
    private GameState previousGameState;
    public bool IsPaused 
    {
        get {
            return PAUSED_GAME_STATES.Contains(GameState);
        }
    }

    // encounter
    private EnemyData currentEncounterEnemy;

    // flounder
    // TODO: maybe add a ScriptableObject to keep track of player stats, like number of battles so far - allows entering a tutorial state
    public float SecondsUntilBattle {
        get {
            return BattleBeginTime - Time.time;
        }
    }
    private float BattleBeginTime;

    private event EventHandler RaisePauseEvent;
    private event EventHandler RaiseUnpauseEvent;
    private event EventHandler<EnemyEventArgs> RaiseEncounterMainEvent;
    private event EventHandler<EnemyEventArgs> RaisePrepareBattleEvent;
    private event EventHandler RaiseCountdownBattleEvent;   // player has hit the button after the 'get ready' screen
    private event EventHandler RaiseStartBattleEvent;   // this is raised to begin the actual flounder minigame
                                                        // TODO: update to maybe take in some event args with enemy?
    private event EventHandler RaiseEndBattleEvent;
    private event EventHandler RaiseEndEncounterEvent;  // TODO: placeholder event for use after post-battle dialogue etc.
    
    public static void RegisterPauseHandler(EventHandler handler)
    {
        Instance.RaisePauseEvent += handler;
    }
    public static void RegisterUnpauseHandler(EventHandler handler)
    {
        Instance.RaiseUnpauseEvent += handler;
    }
    public static void RegisterEncounterMainHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaiseEncounterMainEvent += handler;
    }
    public static void RegisterPrepareBattleHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaisePrepareBattleEvent += handler;
    }
    public static void RegisterCountdownBattleHandler(EventHandler handler)
    {
        Instance.RaiseCountdownBattleEvent += handler;
    }
    public static void RegisterStartBattleHandler(EventHandler handler)
    {
        Instance.RaiseStartBattleEvent += handler;
    }
    public static void RegisterEndBattleHandler(EventHandler handler)
    {
        Instance.RaiseEndBattleEvent += handler;
    }

    void Awake()
    {
        if (Instance != null)
        {
            Debug.LogError("More than one GameStateManager should not exist - it is a singleton");
        }

        Instance = this;
        GameState = GameState.OVERWORLD;    // todo: maybe set this to something else on scene load
        previousGameState = GameState.OVERWORLD;
        currentEncounterEnemy = null;       // todo: if this causes errors, change to some placeholder enemy
    }

    void Start()
    {
        PlayerRun.RegisterEncounterHandler(OnEnemyEncounter);
    }

    void OnApplicationFocus(bool isFocused)
    {
        if (!isFocused && PauseOnFocusLoss)
        {
            PauseGame();
        }
    }

    void Update()
    {
        switch (GameState)
        {
            case GameState.BATTLING:
            {
                if (BattleManager.Instance.IsBattleLeverageAtThreshold)
                {
                    Debug.Log("Battle end");
                    GameState = GameState.BATTLE_END;
                    RaiseEndBattleEvent?.Invoke(this, EventArgs.Empty);
                }
                break;
            }
        }

        if (Input.GetButtonDown("Submit"))
        {
            switch (GameState)
            {
                case GameState.PRE_BATTLE:
                {
                    GameState = GameState.BATTLE_COUNTDOWN;
                    RaiseCountdownBattleEvent?.Invoke(this, EventArgs.Empty);
                    StartCoroutine(RaiseDelayedStartBattleEvent(BATTLE_COUNTDOWN_PERIOD_SECONDS));
                    BattleBeginTime = Time.time + BATTLE_COUNTDOWN_PERIOD_SECONDS;
                    break;
                }
            }
        }

        // As of writing this, 'cancel' is mapped to 'ESC'.
        // Go to Edit > Project Settings > Input Manager to find out if that's changed.
        // Alternatively just use Input.GetKeyDown(KeyCode.Escape)
        else if (Input.GetButtonDown("Cancel")) {
            switch (GameState)
            {
                case GameState.CUTSCENE:
                {
                    // do nothing
                    break;
                }
                case GameState.PAUSED:
                {
                    UnpauseGame();
                    break;
                }
                default:
                {
                    PauseGame();
                    break;
                }
            }
        }
    }

    private void OnEnemyEncounter(object sender, EnemyEventArgs enemyEventArgs)
    {
        // Player has collided with an enemy, begin animations and transition
        GameState = GameState.ENCOUNTER_START;
        currentEncounterEnemy = enemyEventArgs.EnemyData;
        StartCoroutine(RaiseDelayedEncounterMainEvent(ENCOUNTER_DELAY_SECONDS, enemyEventArgs));
    }

    private void PauseGame()
    {
        if (IsPaused) return;

        RaisePauseEvent?.Invoke(this, EventArgs.Empty);
        Time.timeScale = 0f;

        previousGameState = GameState;
        GameState = GameState.PAUSED;
        canTurn = false;
    }

    private void UnpauseGame()
    {
        if (!IsPaused) return;

        RaiseUnpauseEvent?.Invoke(this, EventArgs.Empty);
        Time.timeScale = 1f;

        GameState = previousGameState;
        canTurn = true;
    }

    private IEnumerator RaiseDelayedStartBattleEvent(float seconds)
    {
        yield return new WaitForSeconds(seconds);
        GameState = GameState.BATTLING;
        RaiseStartBattleEvent?.Invoke(this, EventArgs.Empty);
    }

    private IEnumerator RaiseDelayedEncounterMainEvent(float seconds, EnemyEventArgs enemyEventArgs)
    {
        yield return new WaitForSeconds(seconds);
        GameState = GameState.ENCOUNTER_MAIN;
        RaiseEncounterMainEvent?.Invoke(this, enemyEventArgs);
    }

    /* Functions called by player input */
    public void StartFlounder()
    {
        GameState = GameState.PRE_BATTLE;
        RaisePrepareBattleEvent?.Invoke(this, new EnemyEventArgs(currentEncounterEnemy));
    }
}
