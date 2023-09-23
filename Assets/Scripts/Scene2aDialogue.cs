using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.Audio;

public class Scene2aDialogue : MonoBehaviour
{
	public int primeInt = 1; // This integer drives game progress!
	public Text Char1name;
	public Text Char1speech;
	public Text Char2name;
	public Text Char2speech;
	public Text Char3name;
	public Text Char3speech;
	public GameObject dialogue;

	public GameObject ArtChar1;
	public GameObject ArtChar1a;
	public GameObject ArtChar1b;
	public GameObject ArtChar1c;

	public GameObject ArtChar2;
	public GameObject ArtChar2a;
	public GameObject ArtChar2b;
	public GameObject ArtChar2c;

	public GameObject ArtBG1;
	public GameObject Choice1a;
	public GameObject Choice1b;
	public GameObject nextButton;
	public GameObject NextScene1Button;
	public GameObject NextScene2Button;
	//public GameObject gameHandler; 
	//public AudioSource audioSource; 

	void Start()
	{
		dialogue.SetActive(false);
		ArtChar1.SetActive(false);
		ArtChar1a.SetActive(false);
		ArtChar1b.SetActive(false);
		ArtChar1c.SetActive(false);
		ArtChar2.SetActive(false);
		ArtChar2a.SetActive(false);
		ArtChar2b.SetActive(false);
		ArtChar2c.SetActive(false);
		ArtBG1.SetActive(true);
		Choice1a.SetActive(false);
		Choice1b.SetActive(false);
		NextScene1Button.SetActive(false);
		NextScene2Button.SetActive(false);
		nextButton.SetActive(true);
	}

	public void talking()
	{
		primeInt = primeInt + 1;
		// Simple "follow" story units: player hits "Next" button to show each unit
		if (primeInt == 1)
		{
			// audioSource.Play();
		}
		else if (primeInt == 2)
		{
			dialogue.SetActive(true);
			Char1name.text = "YOU";
			Char1speech.text = "Hey, Rags! Are you here?";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
		}
		if (primeInt == 3)
		{
			ArtChar1.SetActive(true);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "RAGU";
			Char3speech.text = "Hello, my human friend!";
		}
		if (primeInt == 3)
		{
			ArtChar1.SetActive(true);
			Char1name.text = "YOU";
			Char1speech.text = "There you are!";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
		}

		if (primeInt == 3)
		{
			ArtChar1.SetActive(true);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "RAGU";
			Char3speech.text = "You seem stressed. Can I get you some tea?";
		}
		else if (primeInt == 4)
		{
			Char1name.text = "YOU";
			Char1speech.text = "Rags, there is someone after you!";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
			//gameHandler.AddPlayerStat(1);
		}
		else if (primeInt == 5)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "RAGU";
			Char3speech.text = "Who would want to come after me?";
		}
		else if (primeInt == 6)
		{
			Char1name.text = "YOU";
			Char1speech.text = "I don't know. They were big, green, and had a badge. What did you do?";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
			//gameHandler.AddPlayerStat(1);
		}
		else if (primeInt == 7)
		{
			ArtChar1a.SetActive(false);
			ArtChar2a.SetActive(true);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "He broke the law. And so did you, running from me. \n Now I take you both in.";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 8)
		{
			ArtChar1a.SetActive(true);
			ArtChar2a.SetActive(false);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "RAGU";
			Char3speech.text = "Flark! You led her right to me!";
		}
		else if (primeInt == 9)
		{
			Char1name.text = "YOU";
			Char1speech.text = "I didn't! I swear!";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 10)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "RAGU";
			Char3speech.text = "Help me! Together we can take her down!";
			// Turn off "Next" button, turn on "Choice1" buttons
			nextButton.SetActive(false);
			Choice1a.SetActive(true); // function Choice1aFunct(), button: "Run Away!"
			Choice1b.SetActive(true); // function Choice1bFunct(), button: "Stay and Fight!"
		}

		// after CHOICE 1a
		else if (primeInt == 20)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "RAGU";
			Char3speech.text = "Where are you going? Don't leave me!";

		}
		else if (primeInt == 21)
		{
			ArtChar1a.SetActive(false);
			ArtChar2a.SetActive(true);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "Hands behind your back, Ragu! You're done.";
			Char3name.text = "";
			Char3speech.text = "";
			nextButton.SetActive(false);
			NextScene1Button.SetActive(true); // function SceneChange1(), button: "Ragu's Fate"
		}

		// after CHOICE 1b
		else if (primeInt == 30)
		{
			ArtChar1.SetActive(false);
			ArtChar2.SetActive(true);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "What do you stupids think you are doing?";
			Char3name.text = "";
			Char3speech.text = "";

		}
		else if (primeInt == 31)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "Ow. That's it. Eat my laser club.";
			Char3name.text = "";
			Char3speech.text = "";
			nextButton.SetActive(false);
			NextScene2Button.SetActive(true);// function SceneChange2(), button: "Your Fate"
		}

		//Do not delete this important end bracket for the next() function!:
	}

	// FUNCTIONS FOR BUTTONS TO ACCESS (Choice #1 and switch scenes)
	public void Choice1aFunct()
	{
		Char1name.text = "YOU";
		Char1speech.text = "You are out of your slimy green mind!";
		Char2name.text = "";
		Char2speech.text = "";
		Char3name.text = "";
		Char3speech.text = "";
		primeInt = 19;
		Choice1a.SetActive(false);
		Choice1b.SetActive(false);
		nextButton.SetActive(true);
	}
	public void Choice1bFunct()
	{
		Char1name.text = "YOU";
		Char1speech.text = "Fine -- you go low, I'll go high!";
		Char2name.text = "";
		Char2speech.text = "";
		Char3name.text = "";
		Char3speech.text = "";
		primeInt = 29;
		Choice1a.SetActive(false);
		Choice1b.SetActive(false);
		nextButton.SetActive(true);
	}

	public void SceneChange2a()
	{
		SceneManager.LoadScene("SceneWin");
	}
	public void SceneChange2b()
	{
		SceneManager.LoadScene("SceneLose");
	}
}