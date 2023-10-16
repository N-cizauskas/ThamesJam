using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.Tracing;
using Ink.Runtime;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class DialogueManager : MonoBehaviour
{
    // Singleton
    public static DialogueManager Instance { get; private set; }

    [Header("Dialogue UI")]
    [SerializeField] private GameObject dialoguePanel;
    [SerializeField] private TextMeshProUGUI dialogueText;

    [Header("Choices UI")]
    [SerializeField] private GameObject[] choiceObjects;

    [Header("Character UI")]
    [SerializeField] private GameObject characterPanel;
    [SerializeField] private TextMeshProUGUI characterText;

    public GameObject continueDialogueButton;

    private Story currentStory;
    private TextMeshProUGUI[] choicesText;
    public bool dialogueIsPlaying { get; private set; } // use this to make decisions about how other things should interact

    private int playerCharm; // Test to see if this can be integrated with the ink script's variable

    [Header("NPC Stats")]
    [SerializeField] private int CThreshold1;
    [SerializeField] private int CThreshold2; // Two charm thresholds if the player has gotten only one or two answers correct

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.LogError("More than one DialogueManager should not exist - it is a singleton");
        }

        Instance = this;
        choicesText = new TextMeshProUGUI[choiceObjects.Length];
        dialogueIsPlaying = false;

        for(int i = 0; i < choiceObjects.Length; i++)
        {
            choicesText[i] = choiceObjects[i].GetComponentInChildren<TextMeshProUGUI>();
        }
    }

    private void Start()
    {
        // Only the start button should be active
        continueDialogueButton.SetActive(false);
        dialoguePanel.SetActive(false);
        characterPanel.SetActive(false);
        playerCharm = PlayerRun.tessieCharm; // Take this from a global tracker or something

        // Register events from GSM
        GameStateManager.RegisterStartFlirtHandler(OnStartFlirt);
    }

    private void OnDestroy()
    {
        GameStateManager.UnregisterStartFlirtHandler(OnStartFlirt);
    }
    
    private void Update() 
    {
        if (!dialogueIsPlaying)
        {
            return;
        }

        // if button pressed, call ContinueDialogue()
        // can use an InputManager to check, or just go with keyPressed
    }

    public void BeginDialogue(EnemyData enemy)
    {
        TextAsset inkJson = enemy.FlirtDialogue;
        currentStory = new Story(inkJson.text);

        // Enable the "continue dialogue" button (this may be overridden by choices in ContinueDialogue)
        continueDialogueButton.SetActive(true);

        // Set player charm in the story

        currentStory.variablesState["charm"] = PlayerRun.tessieCharm;

        // Set the NPC's charm thresholds

        currentStory.variablesState["threshold1"] = CThreshold1;
        currentStory.variablesState["threshold2"] = CThreshold2;

        // Set also the current character to the story's starting character:

        characterText.text = (string)currentStory.variablesState["current_char"];

        dialogueIsPlaying = true;
        dialoguePanel.SetActive(true);
        characterPanel.SetActive(true);
        ContinueDialogue();
    }

    public void PostBossDialogue(EnemyData enemy)
    {
        TextAsset inkJson = enemy.PostBossDialogue;
        currentStory = new Story(inkJson.text);

        // Enable the "continue dialogue" button (this may be overridden by choices in ContinueDialogue)
        continueDialogueButton.SetActive(true);

        // Set player charm in the story

        currentStory.variablesState["charm"] = PlayerRun.tessieCharm;

        // Set the NPC's charm thresholds

        currentStory.variablesState["threshold1"] = CThreshold1;
        currentStory.variablesState["threshold2"] = CThreshold2;

        // Set also the current character to the story's starting character:

        characterText.text = (string)currentStory.variablesState["current_char"];

        dialogueIsPlaying = true;
        dialoguePanel.SetActive(true);
        characterPanel.SetActive(true);
        ContinueDialogue();
    }

    public void ContinueDialogue()
    {
        if (currentStory.canContinue)
        {
            dialogueText.text = currentStory.Continue();
            // Update also the current character that's talking
            characterText.text = (string)currentStory.variablesState["current_char"];
            UpdateChoices();
            UpdateCharbox();
        }
        else
        {
            StartCoroutine(ExitDialogue());
        }
    }

    private IEnumerator ExitDialogue()
    {
        yield return new WaitForSeconds(0.1f);

        dialogueIsPlaying = false;
        dialoguePanel.SetActive(false);
        characterPanel.SetActive(false);
        dialogueText.text = "";

        // Update the player charm after story
        PlayerRun.tessieCharm = (int) currentStory.variablesState["charm"];
        Debug.Log("current playerCharm: " + PlayerRun.tessieCharm);

        // End the "battle"
        // var PR = new PlayerRun();
        // PR.EndBattle();
    }

    private void UpdateChoices()
    {
        List<Choice> currentChoices = currentStory.currentChoices; 

        if (currentChoices.Count > choiceObjects.Length)
        {
            Debug.LogError("Not enough UI GameObjects to support choices");
        }

        for (int i = 0; i < choiceObjects.Length; i++)
        {
            if (i < currentChoices.Count)
            {
                choiceObjects[i].gameObject.SetActive(true);
                choicesText[i].text = currentChoices[i].text;
            }
            else
            {
                choiceObjects[i].gameObject.SetActive(false);
            }
        }

        if (currentChoices.Count > 0)
        {
            // Temporarily disable the continue button until user makes a choice
            continueDialogueButton.SetActive(false);
            StartCoroutine(SelectChoiceObject());
        }
    }

    public void MakeChoice(int choiceIndex)
    {
        currentStory.ChooseChoiceIndex(choiceIndex);
        // Re-enable the continue button
        continueDialogueButton.SetActive(true);
        ContinueDialogue();
    }

    private IEnumerator SelectChoiceObject()
    {
        EventSystem.current.SetSelectedGameObject(null);
        yield return new WaitForEndOfFrame();
        EventSystem.current.SetSelectedGameObject(choiceObjects[0].gameObject);
    }

    private void UpdateCharbox()
    {
        characterPanel.SetActive((bool)currentStory.variablesState["enable_charbox"]);
    }

    void OnStartFlirt(object sender, EnemyEventArgs e)
    {
        CThreshold1 = e.EnemyData.CharmThreshold1;
        CThreshold2 = e.EnemyData.CharmThreshold2;
    }
}
