using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;

public class ToyCity_Instruction : MonoBehaviour
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
            EventLogger.Instance.LogEvent("Quitted the toy city instruction to the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
            SceneManager.LoadScene("DVIM_Main_Menu");
        }    
    }

    public void gotoToyCity()
    {
        EventLogger.Instance.LogEvent("Went to the toy city," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_Toy_City");
    }    
}


