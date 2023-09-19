using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.Tracing;
using Ink.Runtime;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;

public class DialogueManager : MonoBehaviour
{
    public static DialogueManager instance { get; private set; }

    [Header("Dialogue UI")]
    [SerializeField] private GameObject dialoguePanel;
    [SerializeField] private TextMeshProUGUI dialogueText;

    [Header("Choices UI")]
    [SerializeField] private GameObject[] choiceObjects;

    private Story currentStory;
    private TextMeshProUGUI[] choicesText;
    public bool dialogueIsPlaying { get; private set; } // use this to make decisions about how other things should interact

    private void Awake()
    {
        if (instance != null)
        {
            Debug.LogWarning("More than one DialogueManager exists");
        }

        for(int i = 0; i < choiceObjects.Length; i++)
        {
            choicesText[i] = choiceObjects[i].GetComponentInChildren<TextMeshProUGUI>();
        }
        instance = this;
        dialogueIsPlaying = false;
    }

    private void Start()
    {
        dialoguePanel.SetActive(false);
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
        dialogueIsPlaying = true;
        dialoguePanel.SetActive(true);
        ContinueDialogue();
    }

    public void ContinueDialogue()
    {
        if (currentStory.canContinue)
        {
            dialogueText.text = currentStory.Continue();
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
        dialogueText.text = "";
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
