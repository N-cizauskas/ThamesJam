using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.Audio;

public class TestFlirtSceneDialogue : MonoBehaviour
{
    public int primeInt = 1;         // This integer drives game progress!
    public Text Char1name;
    public Text Char1speech;
    public Text Char2name;
    public Text Char2speech;
    public GameObject DialogueDisplay;
    public GameObject ArtChar1;
    public GameObject ArtChar2;
    // Additional game objects reserved for later
    //public GameObject ArtChar3;  - is there any instance where we plan to have more than two characters on-screen at once?
    //public GameObject ArtChar1b;
    //public GameObject ArtChar2b;
    public GameObject ArtBG;
    public GameObject Choicea;
    public GameObject Choiceb;
    public Text ChoiceaText;
    public Text ChoicebText;
    public GameObject NextSceneButton;
    public GameObject nextButton;
    public GameObject FlirtResult;
    public Text FlirtResultText;
    //public AudioSource audioSource;
    private bool allowSpace = true;
    // Additional booleans to flag correct choices
    private bool choice1Passed = false;
    private bool choice2Passed = false;
    // Placeholder for the charm stat
    public int playerCharm = 0;


    // initial visibility settings. Any new images or buttons need to also be SetActive(false);
    void Start()
    {
        DialogueDisplay.SetActive(false);
        ArtChar1.SetActive(true); // Display both characters at the start of scene
        ArtChar2.SetActive(true);
        ArtBG.SetActive(true);
        Choicea.SetActive(false);
        Choiceb.SetActive(false);
        NextSceneButton.SetActive(false);
        nextButton.SetActive(true);
        FlirtResult.SetActive(false);
    }

    void Update()
    {         // use spacebar as Next button
        if (allowSpace == true)
        {
            if (Input.GetKeyDown("space"))
            {
                Next();
            }
        }
    }

    //Story Units! The main story function. Players hit [NEXT] to progress to the next primeInt:
    //Proof of concept plan: Flirting will consist of two pairs of two options.
    //For each pair of options, only one will be considered the "correct" option.
    //If the player chooses the correct option both times, the flirt will be successful regardless of stats.
    //If the player chooses only one correct option, the flirt's success will depend on their "charm" stat.
    //(The threshold can be different for both possibilities that lead to this.)
    //If the player misses both correct options, the flirt will fail regardless of stats.

    //There are two possible implementations: a four-path branch where each possible combination of choices has their own dialogue,
    //or one where the prompt dialogue remains the same after the first set of options (this latter option is similar to P5 negotiations.)
    //We will implement the former here
    public void Next()
    {
        primeInt = primeInt + 1;
        if (primeInt == 1)
        {
            // AudioSource.Play();
        }
        else if (primeInt == 2)
        { 
            DialogueDisplay.SetActive(true);
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "What are you doing in my lair :3";
        }
        else if (primeInt == 3)
        {
            Char1name.text = "Tessie";
            Char1speech.text = "Ummmm... I can explain.";
            Char2name.text = "";
            Char2speech.text = "";
            //gameHandler.AddPlayerStat(1);
        }
        else if (primeInt == 4)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "I'm not the one to write the script, right? -sai";
            // You can add more dialogue, but I will cut it off here and turn on the first choices
            nextButton.SetActive(false);
            allowSpace = false;
            Choicea.SetActive(true);
            Choiceb.SetActive(true);
            ChoiceaText.text = "Actually explain";
            ChoicebText.text = "Ummmm....";
        }

        // after choice 1a
        // We can arbitrarily mark this choice as correct
        else if (primeInt == 1001)
        {
            //gameHandler.AddPlayerStat(1);
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "I see... (this is barebones script sorry :/)";
            choice1Passed = true;
        }
        else if (primeInt == 1002)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "But we are not the same. You are a dinosaur and I am just a lonely fish :(";
            // You can add more dialogue, but I will cut it off here and turn on the choices
            nextButton.SetActive(false);
            allowSpace = false;
            Choicea.SetActive(true);
            Choiceb.SetActive(true);
            ChoiceaText.text = "But I love you";
            ChoicebText.text = "That doesn't matter";
        }

        // branch 1a, after choice 2a
        // This time, this choice is not correct, sorry :(
        else if (primeInt == 1101)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "'Love' is just a word. You can't throw it out willy-nilly like that.";
        }
        else if (primeInt == 1102)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            // Here, we decide based on the player's charm stat
            // You can choose to branch the dialogues further by setting primeInt within these brackets
            if (playerCharm >= 5)
            {
                Char2speech.text = "But I will give my heart anyway since you're so pretty <3";
                choice2Passed = true;
            }
            else
            {
                Char2speech.text = "There are plenty of fish in the sea though. Too bad this one ain't for you!";
            }
            // Set up for the end of the scene
            primeInt = 3000;
        }

        // branch 1a, after choice 2b
        else if (primeInt == 1201)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "You know what, you've definitely convinced me about this.";
        }
        else if (primeInt == 1202)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "Let us carry on in this world, together <3";
            choice2Passed = true;
            // Set up for the end of the scene
            primeInt = 3000;
        }

        // after choice 1b
        else if (primeInt == 2001)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "Then why did you come?";
        }
        else if (primeInt == 2002)
        {
            Char1name.text = "Tessie";
            Char1speech.text = "Uhhh... ummm.... (can't think of anything halp)";
            Char2name.text = "";
            Char2speech.text = "";
        }
        else if (primeInt == 2003)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "You better give a damn good reason because I'm damn pissed now!";
            // Choice time!
            nextButton.SetActive(false);
            allowSpace = false;
            Choicea.SetActive(true);
            Choiceb.SetActive(true);
            ChoiceaText.text = "Explain, for real";
            ChoicebText.text = "Provoke 'em (why?)";
        }

        // branch 1b, after choice 2a
        else if (primeInt == 2101)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "Is that so?";
        }
        else if (primeInt == 2102)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "Well, I'mma now see if your own looks can convince me, if mine can convince you.";
        }
        else if (primeInt == 2103)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            // Here, we decide based on the player's charm stat
            // You can choose to branch the dialogues further by setting primeInt within these brackets
            if (playerCharm >= 5)
            {
                Char2speech.text = "I do see that you are a true dinosaur of culture. I'm youres :)";
                choice2Passed = true;
            }
            else
            {
                Char2speech.text = "(stares at you for 1 second) I'm unconfortable. Bye now";
            }
            // Set up for the end of the scene
            primeInt = 3000;
        }

        // branch 1b, after choice 2b
        else if (primeInt == 2201)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "My name is NOT Dommammu!";
        }
        else if (primeInt == 2202)
        {
            Char1name.text = "";
            Char1speech.text = "";
            Char2name.text = "Fish";
            Char2speech.text = "You're lucky I don't bother to fight you. F off now >:(";
            // Set up for the end of the scene
            primeInt = 3000;
        }

        else if (primeInt == 3001)
        {
            // This is the end of the scene.
            // The results depend on if both flags were tripped
            FlirtResult.SetActive(true);
            if (choice2Passed == true)
            {
                // In this case your flirt is successful!
                // You get a stat!
                FlirtResultText.text = "Flirt Successful!";
                FlirtResultText.color = Color.green;
                playerCharm += 1;
                // Let's reward the player further for a really good flirt
                if (choice1Passed == true)
                {
                    playerCharm += 1;
                }
                // Placeholder to display winning message here
            }
            else
            {
                // Here your flirt has failed :(
                FlirtResultText.text = "Flirt Failed.";
                FlirtResultText.color = Color.red;
                // The fish runs away
                ArtChar2.SetActive(false);
                // Placeholder to display defeat message here
            }
            DialogueDisplay.SetActive(false);
            nextButton.SetActive(false);
            allowSpace = false;
            NextSceneButton.SetActive(true);
        }

        //Please do NOT delete this final bracket that ends the Next() function:
    }

    // FUNCTIONS FOR BUTTONS TO ACCESS (Choice #1 and SceneChanges)
    public void ChoiceaFunct()
    {
        // Set varying responses based on primeInt
        if (primeInt == 4)
        {
            Char1name.text = "Tessie";
            Char1speech.text = "I just wanted to talk with you :3";
            Char2name.text = "";
            Char2speech.text = "";
            primeInt = 1000;
        }
        else if (primeInt == 1002)
        {
            Char1name.text = "Tessie";
            Char1speech.text = "I want to be with you forever though xP";
            Char2name.text = "";
            Char2speech.text = "";
            primeInt = 1100;
        }
        else if (primeInt == 2003)
        {
            Char1name.text = "Tessie";
            Char1speech.text = "I had noticed your good looks and wanted to talk to you about it :D";
            Char2name.text = "";
            Char2speech.text = "";
            primeInt = 2100;
        }
        // These behaviours should be consistent regardless of when it is triggered
        Choicea.SetActive(false);
        Choiceb.SetActive(false);
        nextButton.SetActive(true);
        allowSpace = true;
    }
    public void ChoicebFunct()
    {
        // Set varying responses based on primeInt
        if (primeInt == 4)
        {
            Char1name.text = "Tessie";
            Char1speech.text = "Actually I can't, now that I think about it";
            Char2name.text = "";
            Char2speech.text = "";
            primeInt = 2000;
        }
        else if (primeInt == 1002)
        {
            Char1name.text = "Tessie";
            Char1speech.text = "Has a little difference ever stopped anyone? If anything, we can cover for each other's weaknesses :>";
            Char2name.text = "";
            Char2speech.text = "";
            primeInt = 1200;
        }
        else if (primeInt == 2003)
        {
            Char1name.text = "Tessie";
            Char1speech.text = "I've come to bargain, Dommammu >:(";
            Char2name.text = "";
            Char2speech.text = "";
            primeInt = 2200;
        }
        // These behaviours should be consistent regardless of when it is triggered
        Choicea.SetActive(false);
        Choiceb.SetActive(false);
        nextButton.SetActive(true);
        allowSpace = true;
    }

    public void SceneChange()
    {
        // SceneManager.LoadScene("Test-Sai2a");  //Reload the overworld scene?
    }
}
