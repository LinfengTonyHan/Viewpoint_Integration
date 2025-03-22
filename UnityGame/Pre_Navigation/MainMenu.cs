using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;


public class MainMenu: MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Cursor.visible = true;
        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS)");
        EventLogger.Instance.LogEvent("Accessed the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            EventLogger.Instance.LogEvent("Quitted the experiment via the escape key," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
            Application.Quit();
        }    
    }

    public void startFromBeginning()
    {
        EventLogger.Instance.LogEvent("Started the task from beginning via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_SBSOD");
    }

    public void gotoSBSOD()
    {
        EventLogger.Instance.LogEvent("Entered the SBSOD task via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_SBSOD");
    }

    public void gotoImageRecognition()
    {
        EventLogger.Instance.LogEvent("Entered the image recognition task via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_Image_Recognition");
    }

    public void gotoToyCity()
    {
        EventLogger.Instance.LogEvent("Entered the toy city instructions via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_Toy_City_Instructions");
    }

    public void gotoNavigation1()
    {
        EventLogger.Instance.LogEvent("Entered the 1st navigation session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_City_Main_1");
    }

    public void gotoNavigation2()
    {
        EventLogger.Instance.LogEvent("Entered the 2nd navigation session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_City_Main_2");
    }

    public void gotoNavigation3()
    {
        EventLogger.Instance.LogEvent("Entered the 3rd navigation session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_City_Main_3");
    }

    public void gotoNavigation4()
    {
        EventLogger.Instance.LogEvent("Entered the 4th navigation session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_City_Main_4");
    }

    public void gotoNavigation5()
    {
        EventLogger.Instance.LogEvent("Entered the 5th navigation session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_City_Main_5");
    }

    public void gotoNavigation6()
    {
        EventLogger.Instance.LogEvent("Entered the 6th navigation session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_City_Main_6");
    }

    public void gotoNavigation7()
    {
        EventLogger.Instance.LogEvent("Entered the 7th navigation session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_City_Main_7");
    }


    public void gotoJRD1()
    {
        EventLogger.Instance.LogEvent("Entered the 1st JRD session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_JRD_1");
    }

    public void gotoJRD2()
    {
        EventLogger.Instance.LogEvent("Entered the 2nd JRD session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_JRD_2");
    }

    public void gotoDragDropFinal()
    {
        EventLogger.Instance.LogEvent("Entered the 1st drag and drop session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_Drag_Drop_Final");
    }

    public void gotoPairwiseJudgment()
    {
        EventLogger.Instance.LogEvent("Entered the pairwise judgment session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_Pairwise_Judgment");
    }

    public void gotoJRDfinal()
    {
        EventLogger.Instance.LogEvent("Entered the final JRD session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_JRD_Final");
    }

    public void gotoDistanceEstimation()
    {
        EventLogger.Instance.LogEvent("Entered the distance estimation session via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        SceneManager.LoadScene("DVIM_Distance_Est");
    }

    public void quitExperiment()
    {
        EventLogger.Instance.LogEvent("Quitted the experiment via the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
        Application.Quit();
    }
}
