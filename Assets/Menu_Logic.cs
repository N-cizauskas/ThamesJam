using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Menu_Logic : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    public void QuitGame()
    {
        Application.Quit();

    }

    public void StartGame()

    {
       // SceneManager.LoadScene("Introooooooooooo")

    }


    public void PlayCredits()
    {

        SceneManager.LoadScene("end_credits");

    }



}
