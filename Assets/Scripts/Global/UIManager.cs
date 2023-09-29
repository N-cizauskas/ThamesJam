using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIManager : MonoBehaviour
{
    // Singleton
    public static UIManager Instance { get; private set; }

    [Header("UI Elements")]
    public GameObject pauseBox;

    void Awake()
    {
        if (Instance != null)
        {
            Debug.LogError("More than one UIManager should not exist - it is a singleton");
        }

        Instance = this;
        pauseBox.SetActive(false);
    }

    void Start()
    {
        GameStateManager.RegisterPauseHandler(OnPause);
        GameStateManager.RegisterUnpauseHandler(OnUnpause);
    }

    void OnPause(object sender, EventArgs e)
    {
        pauseBox.SetActive(true);
    }

    void OnUnpause(object sender, EventArgs e)
    {
        pauseBox.SetActive(false);
    }
}
