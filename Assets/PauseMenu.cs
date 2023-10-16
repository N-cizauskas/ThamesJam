using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseMenu : MonoBehaviour
{
    public GameObject PauseBox;



       public static bool gameIsPaused;
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            gameIsPaused = !gameIsPaused;
            PauseGame();
        }
    }
    void PauseGame()
    {
        if (gameIsPaused)
        {
            Time.timeScale = 0f;
            PauseBox.SetActive(true);
        }
        else
        {
            Time.timeScale = 1;
            PauseBox.SetActive(false);
        }
    }

    public void QuitGame()
    {
        Application.Quit();

    }
}

