using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.Tracing;
using Ink.Runtime;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class DialogueManager : MonoBehaviour
{
    public static DialogueManager instance { get; private set; }

    [Header("Dialogue UI")]
    [SerializeField] private GameObject dialoguePanel;
    [SerializeField] private TextMeshProUGUI dialogueText;

    [Header("Choices UI")]
    [SerializeField] private GameObject[] choiceObjects;

    [Header("Character UI")]
    [SerializeField] private GameObject characterPanel;
    [SerializeField] private TextMeshProUGUI characterText;

    private Story currentStory;
    private TextMeshProUGUI[] choicesText;
    public bool dialogueIsPlaying { get; private set; } // use this to make decisions about how other things should interact

    private int playerCharm; // Test to see if this can be integrated with the ink script's variable

    private void Awake()
    {
        if (instance != null)
        {
            Debug.LogWarning("More than one DialogueManager exists");
        }

        choicesText = new TextMeshProUGUI[choiceObjects.Length];
        instance = this;
        dialogueIsPlaying = false;

        for(int i = 0; i < choiceObjects.Length; i++)
        {
            choicesText[i] = choiceObjects[i].GetComponentInChildren<TextMeshProUGUI>();
        }
    }

    private void Start()
    {
        dialoguePanel.SetActive(false);
        characterPanel.SetActive(false);
        playerCharm = 5; // Take this from a global tracker or something
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

    public void BeginDialogue(TextAsset inkJson)
    {
        currentStory = new Story(inkJson.text);

        // Set player charm in the story

        currentStory.variablesState["charm"] = playerCharm;

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
        playerCharm = (int) currentStory.variablesState["charm"];
        Debug.Log("current playerCharm: " + playerCharm);
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
            StartCoroutine(SelectChoiceObject());
        }
    }

    public void MakeChoice(int choiceIndex)
    {
        currentStory.ChooseChoiceIndex(choiceIndex);
        ContinueDialogue();
    }

    private IEnumerator SelectChoiceObject()
    {
        EventSystem.current.SetSelectedGameObject(null);
        yield return new WaitForEndOfFrame();
        EventSystem.current.SetSelectedGameObject(choiceObjects[0].gameObject);
    }
}
