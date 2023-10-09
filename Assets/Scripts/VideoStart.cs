using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Video;

public class VideoStart : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        var videoPlayer = GetComponent<VideoPlayer>();
        videoPlayer.loopPointReached += ChangeScene;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    // Changes the scene to the next level after the video has ended
    void ChangeScene(UnityEngine.Video.VideoPlayer vp)
    {
        Scene scene = SceneManager.GetActiveScene();
        string nextScene = "Level_1";
        // Boring and hacky as shit solution lol
        switch (scene.name)
        {
            case "IceAge_intro":
                nextScene = "Level_1";
                break;
            case "Stink_intro":
                nextScene = "Level_2";
                break;
            case "flood_intro":
                nextScene = "Level_3";
                break;
            case "returnlife_intro":
                nextScene = "Level_4";
                break;
            case "modern_intro":
                nextScene = "Level_5";
                break;
            case "end_credits":
                // TODO ADD MAIN MENU AND MAKE CREDITS SEND TO MENU
                nextScene = "Level_1";
                break;
        }

        SceneManager.LoadScene(nextScene);
    }
}
