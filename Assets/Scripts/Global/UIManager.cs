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
using Unity.VisualScripting;

public class UIManager : MonoBehaviour
{
    // Singleton
    public static UIManager Instance { get; private set; }

    [Header("UI Elements - General")]
    public GameObject PauseBox;

    [Header("UI Elements - Overworld")]
    [Tooltip("The exclamation mark sprite")]
    public GameObject EncounterSprite;

    [Header("UI Elements - Encounter")]
    [Tooltip("The parent game object that houses all encounter UI elements.")]
    public GameObject EncounterRootParent;
    public GameObject PlayerSprite;
    public GameObject EnemySprite;

    [Header("UI Elements - Encounter (Main)")]
    [Tooltip("The parent game object that houses all elements in the main encounter screen.")]
    public GameObject EncounterMainParent;
    [Tooltip("The parent game object that houses the flirt/flounder/flee buttons.")]
    public GameObject EncounterButtons;

    [Header("UI Elements - Encounter (Flirt)")]
    [Tooltip("The parent game object that houses all the flirt dialogue UI elements.")]
    public GameObject FlirtParent;  // we shouldn't need finer control than this - the DialogueManager should handle the rest.

    [Header("UI Elements - Encounter (Flounder)")]
    [Tooltip("The parent game object that houses all the pre-battle UI elements.")]
    public GameObject FlounderParent;
    public GameObject PlayerTitleText;
    public GameObject EnemyTitleText;
    public GameObject EnemySubtitleText;
    public TextMeshProUGUI CenterTitle;
    public TextMeshProUGUI CenterSubtitle;
    public GameObject PlayerBar;
    public GameObject EnemyBar;
    public GameObject Divider;
    public GameObject Hook;
    public GameObject Overlay;
    public GameObject LeverageBar;
    public GameObject PlayerTugGauge;
    public GameObject PlayerTugPullRange;
    public GameObject PlayerTugCritRange;
    public GameObject EnemyTugGauge;
    public GameObject BattleLeverageIndicator;
    public int GaugeWidth;
    public int LeverageWidth;

    [Header("UI Elements - Debug")]
    public GameObject GameStateText;


    private GameObject[] PreBattleElements = {};
    private GameObject[] BattleElements = {};

    private RectTransform PlayerTugPullRangeTransform;
    private RectTransform PlayerTugCritRangeTransform;
    private RectTransform BattleLeverageIndicatorTransform;
    private Image PlayerTugGaugeImage;
    private Image EnemyTugGaugeImage;
    private float leveragePosition;

    // constants for encounter scene
    private static readonly UnityEngine.Vector2 PLAYER_ENCOUNTER_INITIAL_SPRITE_POSITION = new UnityEngine.Vector2(-790, -140);
    private static readonly UnityEngine.Vector2 PLAYER_ENCOUNTER_END_SPRITE_POSITION = new UnityEngine.Vector2(-460, -140);
    private static readonly UnityEngine.Vector2 ENEMY_ENCOUNTER_INITIAL_SPRITE_POSITION = new UnityEngine.Vector2(900, -160);

    // constants for pre-battle screen animation
    private static readonly String CENTER_TITLE_DEFAULT = "Get ready...";
    private static readonly String CENTER_SUBTITLE_DEFAULT = "(ENTER to continue)";
    private static readonly float MAX_DIVIDER_TILT = 20f;
    private static readonly float HOOK_DIVIDER_BOBBING_PERIOD = 2f;
    private static readonly float MAX_HOOK_X = 90;
    private static readonly float HOOK_HEIGHT = 500;
    private static readonly float PLAYER_BAR_FIXED_Y = -50;
    private static readonly float PLAYER_BAR_INITIAL_X = -200;  // negate value for enemy x values
    private static readonly float PLAYER_BAR_FINAL_X = 50;      // negate value for enemy x values

    // additional flair for the battle leverage indicator to make it 'swing' between values
    private static readonly float MAX_LEVERAGE_MOVE_SPEED = 500f;
    private static readonly float LEVERAGE_BOBBING_HEIGHT = 10f;
    private static readonly float LEVERAGE_BOBBING_PERIOD = 1.5f;

    // constants across both
    private static readonly float LEVERAGE_PRE_BATTLE_Y = -80;
    private static readonly float LEVERAGE_BATTLE_Y = 30;


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
    }

    void Start()
    {
        GameStateManager.RegisterPauseHandler(OnPause);
        GameStateManager.RegisterUnpauseHandler(OnUnpause);

        PlayerRun.RegisterEncounterHandler(OnEnemyEncounter);
        GameStateManager.RegisterEncounterMainHandler(OnEncounterStart);

        GameStateManager.RegisterStartFlirtHandler(OnFlirtStart);
        GameStateManager.RegisterEndFlirtHandler(OnFlirtEnd);
        
        GameStateManager.RegisterPrepareBattleHandler(OnPrepareBattle);
        GameStateManager.RegisterCountdownBattleHandler(OnCountdownBattle);
        GameStateManager.RegisterStartBattleHandler(OnStartBattle);
        GameStateManager.RegisterEndBattleHandler(OnEndBattle);

        GameStateManager.RegisterEndEncounterHandler(OnEndEncounter);

        PlayerTugPullRangeTransform = PlayerTugPullRange.GetComponent<RectTransform>();
        PlayerTugCritRangeTransform = PlayerTugCritRange.GetComponent<RectTransform>();
        BattleLeverageIndicatorTransform = BattleLeverageIndicator.GetComponent<RectTransform>();
        PlayerTugGaugeImage = PlayerTugGauge.GetComponent<Image>();
        EnemyTugGaugeImage = EnemyTugGauge.GetComponent<Image>();

        PlayerSprite.SetActive(false);
        EnemySprite.SetActive(false);
        FlounderParent.SetActive(false);
        EncounterButtons.SetActive(false);
        EncounterRootParent.SetActive(false);
        FlirtParent.SetActive(false);
    }

    void Update()
    {
        GameStateText.GetComponent<TextMeshProUGUI>().text = "Game State: " + GameStateManager.Instance.GameState.ToString();

        switch (GameStateManager.Instance.GameState)
        {
            case GameState.PRE_BATTLE:
            {
                UpdateHookPreBattlePosition();
                UpdateHookRotation();
                UpdateDividerPreBattleRotation();
                break;
            }
            case GameState.BATTLE_COUNTDOWN:
            {
                UpdateHookRotation();
                UpdateDividerCountdownRotation();
                UpdateCenterText();
                break;
            }
            case GameState.BATTLING:
            {
                UpdateCritRange();  // TODO: crit range should only need to run when the player starts a new tug
                UpdateTugGauges();
                UpdateBattleLeverageTarget();
                break;
            } 
        }
    }

    void OnPause(object sender, EventArgs e)
    {
        PauseBox.SetActive(true);
    }

    void OnUnpause(object sender, EventArgs e)
    {
        PauseBox.SetActive(false);
    }

    void OnEnemyEncounter(object sender, EnemyEventArgs e)
    {
        EncounterRootParent.SetActive(true);
        PlayerSprite.SetActive(true);
        EnemySprite.SetActive(true);
        PlayerSprite.GetComponent<AdvancedUIMovement>().MoveTo(PLAYER_ENCOUNTER_INITIAL_SPRITE_POSITION);
        EnemySprite.GetComponent<AdvancedUIMovement>().MoveTo(ENEMY_ENCOUNTER_INITIAL_SPRITE_POSITION);
        EnemySprite.GetComponent<Image>().sprite = e.EnemyData.Sprite;

        FlounderParent.SetActive(false);
        ResetBattleLeverage();
        // TODO: set animation length values as defined constants based on GameStateManager.ENCOUNTER_DELAY_SECONDS
        EncounterSprite.GetComponent<AdvancedSpriteMovement>().Pop(e.EnemyData.OverworldPosition, 0.5f, 0.5f);
        StartCoroutine(StartDelayedScreenFadeInOut(0.5f));

    }

    void OnEncounterStart(object sender, EnemyEventArgs e)
    {
        EncounterMainParent.SetActive(true);
        EncounterButtons.SetActive(true);

        PlayerSprite.GetComponent<AdvancedUIMovement>().MoveTo(
            PLAYER_ENCOUNTER_END_SPRITE_POSITION, 1f, AdvancedUIMovement.MoveType.EASE_OUT
        );
        EnemySprite.GetComponent<AdvancedUIMovement>().MoveTo(
            e.EnemyData.EncounterSpritePosition, 1f, AdvancedUIMovement.MoveType.EASE_OUT
        );
    }

    void OnFlirtStart(object sender, EventArgs e)
    {
        FlirtParent.SetActive(true);
        EncounterButtons.SetActive(false);
    }

    void OnFlirtEnd(object sender, EventArgs e)
    {
        // TODO: placeholder for now, the 'flirt' encounter button should be disabled
        // EncounterButtons.SetActive(true);
        FlirtParent.SetActive(false);
    }

    void OnPrepareBattle(object sender, EnemyEventArgs e)
    {
        FlounderParent.SetActive(true);
        EncounterButtons.SetActive(false);
        PlayerTugGauge.SetActive(false);
        EnemyTugGauge.SetActive(false);
        PlayerTugPullRange.SetActive(false);
        PlayerTugCritRange.SetActive(false);

        CenterTitle.color = Color.white;
        CenterTitle.text = CENTER_TITLE_DEFAULT;
        CenterSubtitle.text = CENTER_SUBTITLE_DEFAULT;

        Overlay.GetComponent<OverlayFlash>().Flash(Color.white, 1);
        EnemyTitleText.GetComponent<TextMeshProUGUI>().text = e.EnemyData.Name;
        EnemySubtitleText.GetComponent<TextMeshProUGUI>().text = e.EnemyData.Subtext;

        LeverageBar.GetComponent<AdvancedUIMovement>().MoveTo(new UnityEngine.Vector2(0, LEVERAGE_PRE_BATTLE_Y));
        PlayerBar.GetComponent<AdvancedUIMovement>().MoveTo(new UnityEngine.Vector2(PLAYER_BAR_INITIAL_X, PLAYER_BAR_FIXED_Y));
        EnemyBar.GetComponent<AdvancedUIMovement>().MoveTo(new UnityEngine.Vector2(-PLAYER_BAR_INITIAL_X, PLAYER_BAR_FIXED_Y));
        Hook.GetComponent<AdvancedUIMovement>().MoveTo(new UnityEngine.Vector2(0, 0));
    }

    void OnCountdownBattle(object sender, EventArgs e)
    {
        CenterSubtitle.text = "";

        PlayerBar.GetComponent<AdvancedUIMovement>().MoveTo(
            new UnityEngine.Vector2(PLAYER_BAR_FINAL_X, PLAYER_BAR_FIXED_Y), 
            GameStateManager.BATTLE_COUNTDOWN_PERIOD_SECONDS, 
            AdvancedUIMovement.MoveType.EASE_OUT
        );

        EnemyBar.GetComponent<AdvancedUIMovement>().MoveTo(
            new UnityEngine.Vector2(-PLAYER_BAR_FINAL_X, PLAYER_BAR_FIXED_Y), 
            GameStateManager.BATTLE_COUNTDOWN_PERIOD_SECONDS, 
            AdvancedUIMovement.MoveType.EASE_OUT
        );

        Hook.GetComponent<AdvancedUIMovement>().MoveTo(
            new UnityEngine.Vector2(0, HOOK_HEIGHT),
            GameStateManager.BATTLE_COUNTDOWN_PERIOD_SECONDS * 0.6f,
            AdvancedUIMovement.MoveType.EASE_OUT
        );

        LeverageBar.GetComponent<AdvancedUIMovement>().MoveTo(
            new UnityEngine.Vector2(0, LEVERAGE_BATTLE_Y),
            GameStateManager.BATTLE_COUNTDOWN_PERIOD_SECONDS * 0.6f,
            AdvancedUIMovement.MoveType.EASE_OUT
        );
    }

    void OnStartBattle(object sender, EventArgs e)
    {
        PlayerTugGauge.SetActive(true);
        EnemyTugGauge.SetActive(true);
        PlayerTugPullRange.SetActive(true);
        PlayerTugCritRange.SetActive(true);
        ResetBattleLeverage();
        UpdatePullRange();
        
        CenterTitle.text = "Flounder!";     // TODO: constant?
        StartCoroutine(FadeCenterTitleText());
    }

    void OnEndBattle(object sender, EventArgs e)
    {
        FlounderParent.SetActive(false);
        ResetBattleLeverage();
    }

    void OnEndEncounter(object sender, EventArgs e)
    {
        //TODO: We could use this to remove the enemy
    }

    private IEnumerator StartDelayedScreenFadeInOut(float delayInSeconds)
    {
        yield return new WaitForSeconds(delayInSeconds);
        Overlay.GetComponent<OverlayFlash>().FadeInOut(Color.white, 0.5f, 0.8f);  // TODO: define as constants
        // the idea is that the hold duration overlaps with the EncounterMain event
    }

    // TODO: Respond to RaiseEndBattleEvent
    // TODO: Respond to RaiseEndEncounterEvent

    private IEnumerator FadeCenterTitleText()
    {
        float alpha = 1;
        while (alpha > 0) {
            alpha -= Mathf.Max(0, Time.deltaTime);
            CenterTitle.color = new Color(CenterTitle.color.r, CenterTitle.color.g, CenterTitle.color.b, alpha);
            yield return null;
        }
    }


    private void UpdateHookRotation()
    {
        RectTransform hookTransform = Hook.GetComponent<RectTransform>();
        float tilt = Mathf.Sin(Time.time * Mathf.PI / HOOK_DIVIDER_BOBBING_PERIOD);

        float y = math.remap(-1, 1, -180, 360, tilt);
        hookTransform.rotation = Quaternion.Euler(new UnityEngine.Vector3(0, y, 0));
    }

    private void UpdateHookPreBattlePosition()
    {
        RectTransform hookTransform = Hook.GetComponent<RectTransform>();
        float tilt = Mathf.Sin(Time.time * Mathf.PI / HOOK_DIVIDER_BOBBING_PERIOD);

        float x = math.remap(-1, 1, MAX_HOOK_X, -MAX_HOOK_X, tilt);  // inverted; positive divider z means negative hook y
        hookTransform.anchoredPosition = new UnityEngine.Vector2(x, hookTransform.anchoredPosition.y);
    }

    private void UpdateDividerPreBattleRotation()
    {
        RectTransform dividerTransform = Divider.GetComponent<RectTransform>();
        float tilt = Mathf.Sin(Time.time * Mathf.PI / HOOK_DIVIDER_BOBBING_PERIOD);

        float z = math.remap(-1, 1, -MAX_DIVIDER_TILT, MAX_DIVIDER_TILT, tilt);
        dividerTransform.rotation = Quaternion.Euler(new UnityEngine.Vector3(0, 0, z));
    }

    private void UpdateDividerCountdownRotation()
    {
        RectTransform dividerTransform = Divider.GetComponent<RectTransform>();
        // remap how close we are to battle to -1 to 0
        float countdownPosition = math.remap(GameStateManager.BATTLE_COUNTDOWN_PERIOD_SECONDS, 0, -1, 0, GameStateManager.Instance.SecondsUntilBattle);
        // ease-out rotation that ends at 90y, i.e. invisible
        float rotationY = 720 * Mathf.Pow(countdownPosition, 2) + 90; 

        dividerTransform.rotation = Quaternion.Euler(new UnityEngine.Vector3(0, rotationY, dividerTransform.rotation.eulerAngles.z));
    }

    private void UpdateCenterText()
    {
        CenterTitle.text = Mathf.Ceil(GameStateManager.Instance.SecondsUntilBattle).ToString() + "...";
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

    private void UpdateTugGauges()
    {
        PlayerTugGaugeImage.fillAmount = BattleManager.Instance.playerTugValue / 100f;
        EnemyTugGaugeImage.fillAmount = BattleManager.Instance.enemyTugValue / 100f;
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
