using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GameStateManager : MonoBehaviour
{
    // Singleton
    public static GameStateManager Instance { get; private set; }

    private static readonly GameState[] PAUSED_GAME_STATES = {GameState.OVERWORLD_PAUSED, GameState.FIGHT_PAUSED};
    private static readonly GameState[] PRE_BATTLE_GAME_STATES = {GameState.PRE_FIGHT, GameState.FIGHT_PAUSED};
    private static readonly GameState[] BATTLE_GAME_STATES = {GameState.FIGHT_PLAYING, GameState.FIGHT_PAUSED};

    public static bool canTurn = true;

    [Tooltip("Pause the game on losing focus - disable for easier debugging.")]
    public bool pauseOnFocusLoss = false;

    public GameState GameState { get; private set; }
    public bool IsPaused 
    {
        get {
            return PAUSED_GAME_STATES.Contains(GameState);
        }
    }
    public bool IsInPreBattle
    {
        get {
            return PRE_BATTLE_GAME_STATES.Contains(GameState);
        }
    }
    public bool IsInBattle
    {
        get {
            return BATTLE_GAME_STATES.Contains(GameState);
        }
    }

    private event EventHandler RaisePauseEvent;
    private event EventHandler RaiseUnpauseEvent;
    private event EventHandler<EnemyEventArgs> RaisePrepareBattleEvent;
    private event EventHandler RaiseStartBattleEvent;   // this is raised to begin the actual flounder minigame
                                                        // TODO: update to maybe take in some event args with enemy?
    private event EventHandler RaiseEndBattleEvent;
    
    public static void RegisterPauseHandler(EventHandler handler)
    {
        Instance.RaisePauseEvent += handler;
    }
    public static void RegisterUnpauseHandler(EventHandler handler)
    {
        Instance.RaiseUnpauseEvent += handler;
    }
    public static void RegisterPrepareBattleHandler(EventHandler<EnemyEventArgs> handler)
    {
        Instance.RaisePrepareBattleEvent += handler;
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
        GameState = GameState.OVERWORLD_PLAYING;    // todo: maybe set this to something else on scene load
    }

    void OnApplicationFocus(bool isFocused)
    {
        if (!isFocused && pauseOnFocusLoss)
        {
            PauseGame();
        }
    }

    void Update()
    {
        if (Input.GetButtonDown("Submit"))
        {
            switch(GameState)
            {
                case GameState.PRE_FIGHT:
                {
                    GameState = GameState.FIGHT_PLAYING;
                    RaiseStartBattleEvent?.Invoke(this, EventArgs.Empty);
                    break;
                }
            }
        }

        // As of writing this, 'cancel' is mapped to 'ESC'.
        // Go to Edit > Project Settings > Input Manager to find out if that's changed.
        // Alternatively just use Input.GetKeyDown(KeyCode.Escape)
        else if (Input.GetButtonDown("Cancel")) {
            switch(GameState)
            {
                case GameState.CUTSCENE:
                {
                    // do nothing
                    break;
                }
                case GameState.OVERWORLD_PAUSED:
                case GameState.FIGHT_PAUSED:
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

    private void PauseGame()
    {
        if (IsPaused) return;

        RaisePauseEvent?.Invoke(this, EventArgs.Empty);
        Time.timeScale = 0f;

        // not an elegant method, but better than nothing
        GameState = (GameState == GameState.OVERWORLD_PLAYING) ? GameState.OVERWORLD_PAUSED : GameState.FIGHT_PAUSED;
        canTurn = false;
    }

    private void UnpauseGame()
    {
        if (!IsPaused) return;

        RaiseUnpauseEvent?.Invoke(this, EventArgs.Empty);
        Time.timeScale = 1f;

        GameState = (GameState == GameState.OVERWORLD_PAUSED) ? GameState.OVERWORLD_PLAYING : GameState.FIGHT_PLAYING;
        canTurn = true;
    }

    public void DebugStartPrebattle()
    {
        GameState = GameState.PRE_FIGHT;
        RaisePrepareBattleEvent?.Invoke(this, new EnemyEventArgs("shrimpy"));
    }

    // TODO: remove, used for debugging purposes
    public void DebugStartBattle()
    {
        Debug.Log("debug start battle pressed");
        GameState = GameState.FIGHT_PLAYING;
        RaiseStartBattleEvent?.Invoke(this, EventArgs.Empty);
    }
}
