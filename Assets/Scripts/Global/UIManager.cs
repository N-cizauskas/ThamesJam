using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using System.Runtime.ConstrainedExecution;
using Microsoft.Unity.VisualStudio.Editor;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.UIElements;
using Image = UnityEngine.UI.Image;
using Quaternion = UnityEngine.Quaternion;
using Unity.Mathematics;

public class UIManager : MonoBehaviour
{
    // Singleton
    public static UIManager Instance { get; private set; }

    [Header("UI Elements - General")]
    public GameObject pauseBox;

    [Header("UI Elements - Pre-battle")]
    [Tooltip("The parent game object that houses all the pre-battle UI elements.")]
    public GameObject PreBattleParent;
    public GameObject PlayerTitleText;
    public GameObject EnemyTitleText;
    public GameObject Divider;
    public GameObject Hook;
    public GameObject Overlay;

    [Header("UI Elements - Battle")]
    [Tooltip("The parent game object that houses all the battle UI elements.")]
    public GameObject BattleParent;
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

    // constants for pre-battle screen animation
    private static readonly float MAX_DIVIDER_TILT = 20f;
    private static readonly float HOOK_DIVIDER_BOBBING_PERIOD = 2f;
    private static readonly float MAX_HOOK_X = 90;

    // additional flair for the battle leverage indicator to make it 'swing' between values
    private static readonly float MAX_LEVERAGE_MOVE_SPEED = 500f;
    private static readonly float LEVERAGE_BOBBING_HEIGHT = 10f;
    private static readonly float LEVERAGE_BOBBING_PERIOD = 1.5f;
    private float leveragePosition;

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
        PreBattleParent.SetActive(false);
        BattleParent.SetActive(false);
    }

    void Start()
    {
        GameStateManager.RegisterPauseHandler(OnPause);
        GameStateManager.RegisterUnpauseHandler(OnUnpause);
        GameStateManager.RegisterPrepareBattleHandler(OnPrepareBattle);
        GameStateManager.RegisterStartBattleHandler(OnStartBattle);

        PlayerTugPullRangeTransform = PlayerTugPullRange.GetComponent<RectTransform>();
        PlayerTugCritRangeTransform = PlayerTugCritRange.GetComponent<RectTransform>();
        BattleLeverageIndicatorTransform = BattleLeverageIndicator.GetComponent<RectTransform>();
        PlayerTugGaugeImage = PlayerTugGauge.GetComponent<Image>();
    }

    void Update()
    {
        GameStateText.GetComponent<TextMeshProUGUI>().text = "Game State: " + GameStateManager.Instance.GameState.ToString();

        if (GameStateManager.Instance.IsInPreBattle)
        {
            UpdateHookAndDivider();
        }
        else if (GameStateManager.Instance.IsInBattle)
        {
            // BattleManager.Instance.playerTugValue
            
            UpdateCritRange();  // TODO: crit range should only need to run when the player starts a new tug
            UpdateTugGauge();
            UpdateBattleLeverageTarget();
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

    void OnPrepareBattle(object sender, EnemyEventArgs e)
    {
        PreBattleParent.SetActive(true);
        BattleParent.SetActive(false);
        Overlay.GetComponent<OverlayFlash>().Flash(Color.white, 1);
        EnemyTitleText.GetComponent<TextMeshProUGUI>().text = e.EnemyName;
    }

    void OnStartBattle(object sender, EventArgs e)
    {
        PreBattleParent.SetActive(false);
        BattleParent.SetActive(true);
        ResetBattleLeverage();
        UpdatePullRange();
    }

    // TODO: Respond to RaiseEndBattleEvent

    private void UpdateHookAndDivider()
    {
        RectTransform hookTransform = Hook.GetComponent<RectTransform>();
        RectTransform dividerTransform = Divider.GetComponent<RectTransform>();
        float tilt = Mathf.Sin(Time.time * Mathf.PI / HOOK_DIVIDER_BOBBING_PERIOD);

        float z = math.remap(-1, 1, -MAX_DIVIDER_TILT, MAX_DIVIDER_TILT, tilt);
        dividerTransform.rotation = Quaternion.Euler(new UnityEngine.Vector3(0, 0, z));

        float y = math.remap(-1, 1, -180, 180, tilt);
        hookTransform.rotation = Quaternion.Euler(new UnityEngine.Vector3(0, y, 0));

        float x = math.remap(-1, 1, MAX_HOOK_X, -MAX_HOOK_X, tilt);  // inverted; positive divider z means negative hook y
        hookTransform.anchoredPosition = new UnityEngine.Vector2(x, hookTransform.anchoredPosition.y);
    }

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

    private void UpdateBattleLeverageTarget()
    {
        float leverageCurrent = BattleLeverageIndicatorTransform.anchoredPosition.x;
        float leverageTarget = LeverageWidth * (1 - BattleManager.Instance.battleLeverage / 100f);
        float leverageSpeed = Mathf.Min((leverageTarget - leverageCurrent) * 5, MAX_LEVERAGE_MOVE_SPEED);
        leveragePosition += Time.deltaTime * leverageSpeed;
        BattleLeverageIndicatorTransform.SetX(Mathf.Clamp(leveragePosition, 0, LeverageWidth));

        // for flair, let's bob it up and down as well
        BattleLeverageIndicatorTransform.SetY(LEVERAGE_BOBBING_HEIGHT * Mathf.Sin(Time.time * Mathf.PI / LEVERAGE_BOBBING_PERIOD));
    }

    private void ResetBattleLeverage()
    {
        leveragePosition = LeverageWidth * (1 - BattleManager.BASE_BATTLE_LEVERAGE / 100f);
        BattleLeverageIndicatorTransform.SetX(Mathf.Clamp(leveragePosition, 0, LeverageWidth));
    }
}
