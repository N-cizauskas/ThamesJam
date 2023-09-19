using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.Audio;

public class TestFlirtIntro : MonoBehaviour
{
    public Text MobName;
    public Text MobFlavor;
    public GameObject ImageMob;
    public GameObject ArtBG;
    public GameObject ChoiceFight;
    public GameObject ChoiceFlirt;
    public GameObject ChoiceFlee;
    // Text for fight/flirt/flee (in case you want some oomph!)
    public Text ChoiceFightText;
    public Text ChoiceFlirtText;
    public Text ChoiceFleeText;

    public GameObject MobDesc;
    //public AudioSource audioSource;

    // initial visibility settings. Any new images or buttons need to also be SetActive(false);
    void Start()
    {
        // Activate the stuff in this scene
        ImageMob.SetActive(true);
        ArtBG.SetActive(true);
        ChoiceFight.SetActive(true);
        ChoiceFlirt.SetActive(true);
        ChoiceFlee.SetActive(true);
        MobDesc.SetActive(true);

        // Let's also set the text of MobDesc
        MobName.text = "Iceberg Fish";
        MobFlavor.text = "A bit cool";

        // Here's also the option to set up the custom text for options:
        //ChoiceFightText.text = "Fight";
        //ChoiceFlirtText.text = "Flirt";
        //ChoiceFleeText.text = "Flee";
    }

    // Now define functions to place the player in the appropriate scene after clicking any of the choices
    public void ChoiceFightClick()
    {
        // SceneManager.LoadScene("Test-FightScene");
    }

    public void ChoiceFlirtClick()
    {
        SceneManager.LoadScene("Test-FlirtScene");
    }

    public void ChoiceFleeClick()
    {
        // Return to the overworld
        // SceneManager.LoadScene("Overworld");
    }
}