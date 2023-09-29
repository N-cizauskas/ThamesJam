using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameStateManager : MonoBehaviour
{
    // Singleton
    public static GameStateManager Instance { get; private set; }

    public GameState GameState { get; private set; }
    private event EventHandler RaisePauseEvent;
    private event EventHandler RaiseUnpauseEvent;

    public static void RegisterPauseHandler(EventHandler handler)
    {
        Instance.RaisePauseEvent += handler;
    }
    public static void RegisterUnpauseHandler(EventHandler handler)
    {
        Instance.RaiseUnpauseEvent += handler;
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
        if (!isFocused)
        {
            PauseGame();
        }
    }

    void Update()
    {
        // As of writing this, 'cancel' is mapped to 'ESC'.
        // Go to Edit > Project Settings > Input Manager to find out if that's changed.
        // Alternatively just use Input.GetKeyDown(KeyCode.Escape)
        if (Input.GetButtonDown("Cancel")) {
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
        RaisePauseEvent?.Invoke(this, EventArgs.Empty);
        Time.timeScale = 0f;

        // not an elegant method, but better than nothing
        GameState = (GameState == GameState.OVERWORLD_PLAYING) ? GameState.OVERWORLD_PAUSED : GameState.FIGHT_PAUSED;
    }

    private void UnpauseGame()
    {
        RaiseUnpauseEvent?.Invoke(this, EventArgs.Empty);
        Time.timeScale = 1f;

        GameState = (GameState == GameState.OVERWORLD_PAUSED) ? GameState.OVERWORLD_PLAYING : GameState.FIGHT_PLAYING;
    }
}
