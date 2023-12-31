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
    private static readonly GameState[] ENCOUNTER_GAME_STATES =
    {
        GameState.ENCOUNTER_START,
        GameState.ENCOUNTER_MAIN,
        GameState.ENCOUNTER_FLIRT,
        GameState.PRE_BATTLE,
        GameState.BATTLE_COUNTDOWN,
        GameState.BATTLING,
        GameState.BATTLE_END,
        GameState.ENCOUNTER_END,
        GameState.POST_BOSS_START,
        GameState.POST_BOSS_DIALOGUE,
        GameState.BOSS_START
    };

    public static bool canTurn = true;
    public static bool inEncounter = false;

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
    public bool IsEncounter
    {
        get
        {
            return ENCOUNTER_GAME_STATES.Contains(GameState);
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
    private event EventHandler<EnemyEventArgs> RaiseStartFlirtEvent;
    private event EventHandler RaiseEndFlirtEvent;
    private event EventHandler<EnemyEventArgs> RaisePrepareBattleEvent;
    private event EventHandler RaiseCountdownBattleEvent;   // player has hit the button after the 'get ready' screen
    private event EventHandler RaiseStartBattleEvent;   // this is raised to begin the actual flounder minigame
                                                        // TODO: update to maybe take in some event args with enemy?
    private event EventHandler RaiseEndBattleEvent;
    private event EventHandler RaiseEndBossBattleEvent;
    private event EventHandler RaiseEndEncounterEvent;  // TODO: placeholder event for use after post-battle dialogue etc.
    private event EventHandler<EnemyEventArgs> RaiseBossEncounterEvent;
    private event EventHandler RaiseEndBossFlirtEvent;
    private event EventHandler RaiseEndBossEvent;
    
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
    public static void RegisterBossEncounterHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaiseBossEncounterEvent += handler;
    }
    public static void RegisterStartFlirtHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaiseStartFlirtEvent += handler;
    }
    public static void RegisterEndFlirtHandler(EventHandler handler)
    {
        Instance.RaiseEndFlirtEvent += handler;
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
    public static void RegisterEndBossBattleHandler(EventHandler handler)
    {
        Instance.RaiseEndBossBattleEvent += handler;
    }
    public static void RegisterEndBossFlirtHandler(EventHandler handler)
    {
        Instance.RaiseEndBossFlirtEvent += handler;
    }
    public static void RegisterEndEncounterHandler(EventHandler handler)
    {
        Instance.RaiseEndEncounterEvent += handler;
    }
    public static void RegisterEndBossHandler(EventHandler handler)
    {
        Instance.RaiseEndBossEvent += handler;
    }
    public static void UnregisterPauseHandler(EventHandler handler)
    {
        Instance.RaisePauseEvent -= handler;
    }
    public static void UnregisterUnpauseHandler(EventHandler handler)
    {
        Instance.RaiseUnpauseEvent -= handler;
    }
    public static void UnregisterEncounterMainHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaiseEncounterMainEvent -= handler;
    }
    public static void UnregisterBossEncounterHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaiseBossEncounterEvent -= handler;
    }
    public static void UnregisterStartFlirtHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaiseStartFlirtEvent -= handler;
    }
    public static void UnregisterEndFlirtHandler(EventHandler handler)
    {
        Instance.RaiseEndFlirtEvent -= handler;
    }
    public static void UnregisterPrepareBattleHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaisePrepareBattleEvent -= handler;
    }
    public static void UnregisterCountdownBattleHandler(EventHandler handler)
    {
        Instance.RaiseCountdownBattleEvent -= handler;
    }
    public static void UnregisterStartBattleHandler(EventHandler handler)
    {
        Instance.RaiseStartBattleEvent -= handler;
    }
    public static void UnregisterEndBattleHandler(EventHandler handler)
    {
        Instance.RaiseEndBattleEvent -= handler;
    }
    public static void UnregisterEndBossBattleHandler(EventHandler handler)
    {
        Instance.RaiseEndBossBattleEvent -= handler;
    }
    public static void UnregisterEndBossFlirtHandler(EventHandler handler)
    {
        Instance.RaiseEndBossFlirtEvent -= handler;
    }
    public static void UnregisterEndEncounterHandler(EventHandler handler)
    {
        Instance.RaiseEndEncounterEvent -= handler;
    }
    public static void UnregisterEndBossHandler(EventHandler handler)
    {
        Instance.RaiseEndBossEvent -= handler;
    }

    void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else {
            Instance = this;
        }
        Instance = this;
        GameState = GameState.OVERWORLD;    // todo: maybe set this to something else on scene load
        previousGameState = GameState.OVERWORLD;
        currentEncounterEnemy = null;       // todo: if this causes errors, change to some placeholder enemy
    }

    void Start()
    {
        PlayerRun.RegisterEncounterHandler(OnEnemyEncounter);
        PlayerRun.RegisterBossEncounterHandler(OnBossEncounter);
        GameState = GameState.OVERWORLD;
        currentEncounterEnemy = null;
    }
    void OnDestroy()
    {
        PlayerRun.UnregisterEncounterHandler(OnEnemyEncounter);
        PlayerRun.UnregisterBossEncounterHandler(OnBossEncounter);
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
        if (IsEncounter)
        {
            inEncounter = true;
            canTurn = false;
        } else
        {
            inEncounter = false;
            canTurn = true;
        }
        switch (GameState)
        {
            case GameState.ENCOUNTER_FLIRT:
            {
                if (!DialogueManager.Instance.dialogueIsPlaying)
                {
                    if (currentEncounterEnemy.IsBoss)
                    {
                        RaiseEndBossFlirtEvent?.Invoke(this, EventArgs.Empty);
                        Debug.Log("Boss Dialogue End: Start battle");
                        GameState = GameState.PRE_BATTLE;
                        RaisePrepareBattleEvent?.Invoke(this, new EnemyEventArgs(currentEncounterEnemy));                      
                    }
                    else {
                        Debug.Log("Dialogue end");
                        GameState = GameState.ENCOUNTER_END;
                        RaiseEndFlirtEvent?.Invoke(this, EventArgs.Empty);
                    }
                }
                break;
            }
            case GameState.POST_BOSS_DIALOGUE:
            {
                if (!DialogueManager.Instance.dialogueIsPlaying)
                {
                    Debug.Log("Dialogue end");
                    GameState = GameState.OVERWORLD;
                    RaiseEndBossEvent?.Invoke(this, EventArgs.Empty);
                }
                break;
            }
            case GameState.BATTLING:
            {
                if (BattleManager.Instance.IsBattleLeverageAtThreshold)
                {
                    if (currentEncounterEnemy.IsBoss)
                    {
                        GameState = GameState.POST_BOSS_DIALOGUE;
                        RaiseEndBossBattleEvent?.Invoke(this, EventArgs.Empty);
                        RaiseStartFlirtEvent?.Invoke(this, new EnemyEventArgs(currentEncounterEnemy));
                        DialogueManager.Instance.PostBossDialogue(currentEncounterEnemy);
                    }
                    else {
                        Debug.Log("Battle end");
                        GameState = GameState.BATTLE_END;
                        RaiseEndBattleEvent?.Invoke(this, EventArgs.Empty);
                    }
                }
                break;
            }
            case GameState.ENCOUNTER_END:
            {

                GameState = GameState.OVERWORLD;
                break;
            }
            case GameState.BATTLE_END:
            {
                //Boss battle check
                GameState = GameState.OVERWORLD;
                break;
            }
            case GameState.BOSS_MAIN:
            {
                GameState = GameState.ENCOUNTER_FLIRT;
                RaiseStartFlirtEvent?.Invoke(this, new EnemyEventArgs(currentEncounterEnemy));
                DialogueManager.Instance.BeginDialogue(currentEncounterEnemy);
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

    private void OnBossEncounter(object sender, EnemyEventArgs enemyEventArgs)
    {
        GameState = GameState.BOSS_START;
        currentEncounterEnemy = enemyEventArgs.EnemyData;
        StartCoroutine(RaiseDelayedBossMainEvent(ENCOUNTER_DELAY_SECONDS, enemyEventArgs));
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

    private IEnumerator RaiseDelayedBossMainEvent(float seconds, EnemyEventArgs enemyEventArgs)
    {
        yield return new WaitForSeconds(seconds);
        GameState = GameState.BOSS_MAIN;
        RaiseBossEncounterEvent?.Invoke(this, enemyEventArgs);
    }

    /* Functions called by player input */
    public void StartFlirt()
    {
        GameState = GameState.ENCOUNTER_FLIRT;
        RaiseStartFlirtEvent?.Invoke(this, new EnemyEventArgs(currentEncounterEnemy));
        DialogueManager.Instance.BeginDialogue(currentEncounterEnemy);
    }

    public void StartFlounder()
    {
        GameState = GameState.PRE_BATTLE;
        RaisePrepareBattleEvent?.Invoke(this, new EnemyEventArgs(currentEncounterEnemy));
    }

    public void StartFlee()
    {
        //TODO: Remove the object and reset the gamestate
        GameState = GameState.OVERWORLD;
        RaiseEndEncounterEvent?.Invoke(this, new EnemyEventArgs(currentEncounterEnemy));
    }

    /* DEBUG functions */
    public void DebugRaiseEndBossEvent(EnemyData enemy)
    {
        BattleManager.Instance.DebugSetBossCheck(enemy);
        RaiseEndBossEvent?.Invoke(this, EventArgs.Empty);
    }
}
