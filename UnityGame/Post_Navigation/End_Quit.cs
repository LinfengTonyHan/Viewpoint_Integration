using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;

public class End_Quit : MonoBehaviour
{
    void Start()
    {
        Cursor.visible = true;
        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS)");
        EventLogger.Instance.LogEvent("Finished all seven navigation sessions," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
    }
    // Update is called once per frame
    void Update()
    {

    if (Input.GetKeyDown(KeyCode.Escape))
        {
            Application.Quit();
        }

    }
}
