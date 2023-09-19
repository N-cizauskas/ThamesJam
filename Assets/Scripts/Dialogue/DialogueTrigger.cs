using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogueTrigger : MonoBehaviour
{
    [Header("Ink JSON")]
    [SerializeField] private TextAsset inkJSON;

    private void Update() 
    {
        // on [thing] occurring, call EnterDialogue.
    }

    private void EnterDialogue()
    {
        DialogueManager.instance.BeginDialogue(inkJSON);
    }
}