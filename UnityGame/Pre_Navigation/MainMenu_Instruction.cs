using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;


public class MainMenu_Instruction : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS)");
        EventLogger.Instance.LogEvent("Experiment started," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            EventLogger.Instance.LogEvent("Quitted the experiment via the escape key," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
            Application.Quit();
        }

        if (Input.GetKeyDown(KeyCode.M))
        {
            EventLogger.Instance.LogEvent("Entered the main menu from the first page," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
            SceneManager.LoadScene("DVIM_Main_Menu");
        }
    }

    public void clickStart()
    {
        EventLogger.Instance.LogEvent("Experiment started and entered the SBSOD task," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_SBSOD");
    }
    
}

