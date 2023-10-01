using System;
using System.Collections;
using System.Collections.Generic;
using Microsoft.Unity.VisualStudio.Editor;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using Image = UnityEngine.UI.Image;

public class UIManager : MonoBehaviour
{
    // Singleton
    public static UIManager Instance { get; private set; }

    [Header("UI Elements - General")]
    public GameObject pauseBox;

    [Header("UI Elements - Battle")]
    [Tooltip("The parent game object that houses all the battle UI elements.")]
    public GameObject BattleParentGameObject;
    public GameObject PlayerTugGauge;
    public GameObject PlayerTugPullRange;
    public GameObject PlayerTugCritRange;
    public GameObject BattleLeverageIndicator;
    public int GaugeWidth;
    public int LeverageWidth;

    [Header("UI Elements - Debug")]
    public GameObject GameStateText;

    private RectTransform PlayerTugPullRangeTransform;
    private RectTransform PlayerTugCritRangeTransform;
    private RectTransform BattleLeverageIndicatorTransform;
    private Image PlayerTugGaugeImage;

    void Awake()
    {
        if (Instance != null)
        {
            Debug.LogError("More than one UIManager should not exist - it is a singleton");
        }
        if (GaugeWidth <= 0)
        {
            Debug.LogWarning("Gauge width needs to be set for battles to display properly");
        }

        Instance = this;
        BattleParentGameObject.SetActive(false);
    }

    void Start()
    {
        GameStateManager.RegisterPauseHandler(OnPause);
        GameStateManager.RegisterUnpauseHandler(OnUnpause);
        GameStateManager.RegisterStartBattleHandler(OnStartBattle);

        PlayerTugPullRangeTransform = PlayerTugPullRange.GetComponent<RectTransform>();
        PlayerTugCritRangeTransform = PlayerTugCritRange.GetComponent<RectTransform>();
        BattleLeverageIndicatorTransform = BattleLeverageIndicator.GetComponent<RectTransform>();
        PlayerTugGaugeImage = PlayerTugGauge.GetComponent<Image>();
    }

    void Update()
    {
        GameStateText.GetComponent<TextMeshProUGUI>().text = "Game State: " + GameStateManager.Instance.GameState.ToString();

        if (GameStateManager.Instance.IsInBattle)
        {
            // BattleManager.Instance.playerTugValue
            
            UpdateCritRange();  // TODO: crit range should only need to run when the player starts a new tug
            UpdateTugGauge();
            UpdateBattleLeverage();
        }
    }

    void OnPause(object sender, EventArgs e)
    {
        pauseBox.SetActive(true);
    }

    void OnUnpause(object sender, EventArgs e)
    {
        pauseBox.SetActive(false);
    }

    void OnStartBattle(object sender, EventArgs e)
    {
        BattleParentGameObject.SetActive(true);
        UpdatePullRange();
    }

    // TODO: Respond to RaiseEndBattleEvent

    private void UpdatePullRange()
    {
        PlayerTugPullRangeTransform.SetLeft(GaugeWidth * (BattleManager.Instance.playerTugRangeMin / 100f));
        PlayerTugPullRangeTransform.SetRight(0);
    }

    private void UpdateCritRange()
    {
        PlayerTugCritRange.SetActive(BattleManager.Instance.playerTugging);
        PlayerTugCritRangeTransform.SetLeft(GaugeWidth * (BattleManager.Instance.playerTugCritRangeMin / 100f));
        PlayerTugCritRangeTransform.SetRight(GaugeWidth * (1 - BattleManager.Instance.playerTugCritRangeMax / 100f));
    }

    private void UpdateTugGauge()
    {
        PlayerTugGaugeImage.fillAmount = BattleManager.Instance.playerTugValue / 100f;
    }

    private void UpdateBattleLeverage()
    {
        float transformX = LeverageWidth * (1 - BattleManager.Instance.battleLeverage / 100f);
        BattleLeverageIndicatorTransform.SetX(Mathf.Clamp(transformX, 0, LeverageWidth));
    }
}
