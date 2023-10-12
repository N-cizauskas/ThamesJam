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

    void OnValidate()
    {
        if (EffectAudioSource == null || BackgroundAudioSource == null)
        {
            Debug.LogWarning("AudioManager has at least one audio source not set yet; some sounds might not play");
        }
    }

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
        PlayEffect(PauseClip);
        
        if (BackgroundAudioSource != null)
        {
            BackgroundAudioSource.Pause();
        }
    }

    void OnUnpause(object sender, EventArgs e)
    {
        PlayEffect(UnpauseClip);

        if (BackgroundAudioSource != null)
        {
            BackgroundAudioSource.UnPause();
        }
    }

    private void PlayEffect(AudioClip clip)
    {
        // Cannot use null propagation with unity objects; EffectAudioSource?.Play() would cause unintended behaviour
        if (EffectAudioSource != null)
        {
            EffectAudioSource.clip = clip;
            EffectAudioSource.Play();
        }
    }
}
