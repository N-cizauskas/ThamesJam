using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.Audio;

public class Scene2bDialogue : MonoBehaviour
{
	public int primeInt = 1; // This integer drives game progress!
	public Text Char1name;
	public Text Char1speech;
	public Text Char2name;
	public Text Char2speech;
	public Text Char3name;
	public Text Char3speech;
	public GameObject DialogueDisplay;

	public GameObject ArtChar1a;
	public GameObject ArtChar1b;
	public GameObject ArtChar1c;

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
		DialogueDisplay.SetActive(false);
		ArtChar1a.SetActive(false);
		ArtChar1b.SetActive(false);
		ArtChar1c.SetActive(false);
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
			DialogueDisplay.SetActive(true);
			ArtChar1a.SetActive(false);
			ArtChar2a.SetActive(true);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "So? Where is he? Where is Rago Fahn?";
			Char3name.text = "";
			Char3speech.text = "";
		}
		if (primeInt == 3)
		{
			Char1name.text = "YOU";
			Char1speech.text = "I don't know what to tell you. This is his alley.";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 4)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "What do you mean, 'his' alley?";
			Char3name.text = "";
			Char3speech.text = "";
			//gameHandler.AddPlayerStat(1);
		}
		else if (primeInt == 5)
		{
			Char1name.text = "YOU";
			Char1speech.text = "Where he does business. Hey... you should hide.";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 6)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "HIDE? I am Jeda of planet Jarda. I do not hide from criminals!";
			Char3name.text = "";
			Char3speech.text = "";
			//gameHandler.AddPlayerStat(1);
		}
		else if (primeInt == 7)
		{
			Char1name.text = "YOU";
			Char1speech.text = "Trust me! Ragu is squirrelly, and fast. He sees you, he'll run.";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 8)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "(...)";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 9)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "Fine. Where do you suggest I hide?";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 10)
		{
			Char1name.text = "YOU";
			Char1speech.text = "Behind that dumpster. Quick-- I hear him coming!";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 11)
		{
			ArtChar1a.SetActive(true);
			ArtChar2a.SetActive(false);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "RAGU";
			Char2speech.text = "Hello, my human friend! Long time!";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 12)
		{
			Char1name.text = "YOU";
			Char1speech.text = "(What do I do? Do I turn him in?)";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
			// Turn off "Next" button, turn on "Choice" buttons
			nextButton.SetActive(false);
			Choice1a.SetActive(true); // function Choice1aFunct() Button: "Warn Ragu"
			Choice1b.SetActive(true); // function Choice1bFunct() Button: "Play it cool"
		}

		// after CHOICE 1a:
		else if (primeInt == 20)
		{
			ArtChar1a.SetActive(false);
			ArtChar2a.SetActive(true);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "I knew you could not be trusted!";
			Char3name.text = "";
			Char3speech.text = "";

		}
		else if (primeInt == 21)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "Get back here, both of you! Agh-- what did I step in?!";
			Char3name.text = "";
			Char3speech.text = "";
			nextButton.SetActive(false);
			NextScene1Button.SetActive(true);  // function SceneChange1() Button: "Ragu's Fate"
		}

		// after CHOICE 1b:
		else if (primeInt == 30)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "RAGU";
			Char3speech.text = "Not bad at all. What brings you around?";

		}
		else if (primeInt == 31)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "Ragu Fahn, you are under arrest.";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 32)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "RAGU";
			Char3speech.text = "You betrayed me???";

		}
		else if (primeInt == 33)
		{
			Char1name.text = "YOU";
			Char1speech.text = "I'm sorry, Ragu! She beat me up!";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";

		}
		else if (primeInt == 34)
		{
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "Yes, humans are very weak.";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 35)
		{
			Char1name.text = "YOU";
			Char1speech.text = "Hey!";
			Char2name.text = "";
			Char2speech.text = "";
			Char3name.text = "";
			Char3speech.text = "";
		}
		else if (primeInt == 36)
		{
			ArtChar1a.SetActive(false);
			ArtChar2a.SetActive(true);
			Char1name.text = "";
			Char1speech.text = "";
			Char2name.text = "JEDA";
			Char2speech.text = "I am arresting you too, stupid human.";
			Char3name.text = "";
			Char3speech.text = "";
			nextButton.SetActive(false);
			NextScene2Button.SetActive(true);  // function SceneChange1() Button: "Your Fate"
		}
	}

	// FUNCTIONS FOR BUTTONS TO ACCESS (Choice #1 and switch scenes)
	public void Choice1aFunct()
	{
		Char1name.text = "YOU";
		Char1speech.text = "Rags, you have to run! Now!";
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
		Char1speech.text = "Hey, Rags! How's it hanging?";
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
