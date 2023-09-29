using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    // Singleton
    public static AudioManager Instance { get; private set; }

    [Header("Sounds")]
    public AudioSource BackgroundAudioSource;
    public AudioSource EffectAudioSource;
    public AudioClip PauseClip;
    public AudioClip UnpauseClip;

    void Awake()
    {
        if (Instance != null)
        {
            Debug.LogError("More than one AudioManager should not exist - it is a singleton");
        }
        
        Instance = this;
    }

    void Start()
    {
        GameStateManager.RegisterPauseHandler(OnPause);
        GameStateManager.RegisterUnpauseHandler(OnUnpause);
    }

    void OnPause(object sender, EventArgs e)
    {
        EffectAudioSource.clip = PauseClip;
        EffectAudioSource.Play();
        BackgroundAudioSource.Pause();
    }

    void OnUnpause(object sender, EventArgs e)
    {
        EffectAudioSource.clip = UnpauseClip;
        EffectAudioSource.Play();
        BackgroundAudioSource.UnPause();
    }
}
