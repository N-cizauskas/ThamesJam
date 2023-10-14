using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogueTrigger : MonoBehaviour
{
    [Header("Ink JSON")]
    [SerializeField] private EnemyData enemy;

    private void Update() 
    {
        // on [thing] occurring, call EnterDialogue.
    }

    // this method should usually be private, I think; making it public for testing purposes
    public void EnterDialogue()
    {
        DialogueManager.Instance.BeginDialogue(enemy);
    }
}