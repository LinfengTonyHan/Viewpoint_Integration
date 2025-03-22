using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;

public class City_Main_Instruction : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Cursor.visible = true;

        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS)");  
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape)) // Quit to the main menu
        {
            SceneManager.LoadScene("DVIM_Main_Menu");
            EventLogger.Instance.LogEvent("Quitted the main city instructions to the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
        }    
    }

    public void gotoMainCity()
    {
        EventLogger.Instance.LogEvent("Entered the first navigation session," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_City_Main_1");
    }    
}


