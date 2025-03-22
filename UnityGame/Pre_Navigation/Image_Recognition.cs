using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;

public class Image_Recognition : MonoBehaviour
{
    [Header("Interactables")]
    public Image mainImage;
    public Image targetImage;
    public Text instructionStart;
    public Text instructionTarget;
    public Text instructionSpace;
    public Text instructionEnd;

    [Header("Non-Interactables")]
    public Image target;
    public Image[] stimuli;
    public int trialAll = 48; // 48 trials in total, with 40 store images and 8 target images.

    private int trialNum;
    private bool testingStart;
    private bool testingEnd;
    private float curTime = 0.0f;
    private float trialDur = 3.0f;
    private string next_scene_name = "DVIM_Toy_City_Instructions";

    // Start is called before the first frame update
    void Start()
    {
        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS), Trial Number, Elapsed Time");

        trialNum = 0;
        mainImage.enabled = false;
        targetImage.enabled = true;
        targetImage.sprite = target.sprite;

        instructionStart.enabled = true;
        instructionTarget.enabled = true;
        instructionSpace.enabled = false;
        instructionEnd.enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        // trial number is based on time; each trial last 3 seconds (2s display + 1s blank)
        trialNum = Convert.ToInt32(Math.Floor(curTime / trialDur));
        print(trialNum);

        if (Input.GetKeyDown(KeyCode.S))
        {
            testingStart = true;
            EventLogger.Instance.LogEvent("Image recognition test started," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -");
        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene("DVIM_Main_Menu");
            EventLogger.Instance.LogEvent("Image recognition tested quitted and entered the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -");
        }

        if (Input.GetKeyDown(KeyCode.N))
        {
            if (testingEnd)
            {
                SceneManager.LoadScene(next_scene_name);
                EventLogger.Instance.LogEvent("Image recognition test ended and entered the toy city instructions," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -");
            }
        }

        if (Input.GetKeyDown(KeyCode.Space)) // The participant makes a key press (response to indicate seeing the target image)
        {
            EventLogger.Instance.LogEvent("SPACE bar pressed," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialNum.ToString() + "," + curTime.ToString());
        }

        if (trialNum == trialAll) // After reaching the last trial: end the testing session
        {
            testingEnd = true;
        }

        if (testingStart && !testingEnd) // During the test
        {
            curTime = Time.deltaTime + curTime;
            mainImage.enabled = true;
            targetImage.enabled = false;
            instructionStart.enabled = false;
            instructionTarget.enabled = false;
            instructionSpace.enabled = true;
            instructionEnd.enabled = false;
        }

        if (testingEnd) // Testing session ends
        {
            curTime = 0;
            mainImage.enabled = false;
            targetImage.enabled = false;
            instructionStart.enabled = false;
            instructionTarget.enabled = false;
            instructionSpace.enabled = false;
            instructionEnd.enabled = true;
        }

        if (testingStart && trialNum < trialAll) // Make sure that trialNum doesn't equal to trialAll (otherwise will exceed array bound)
        {
            mainImage.sprite = stimuli[trialNum].sprite;
            if ((curTime % trialDur) <= 2.1 && (curTime % trialDur) > 0.1) // Give a 0.1s time for the sprite to update; First trial will begin at 0.1s.
            {
                mainImage.enabled = true;
            }

            else
            {
                mainImage.enabled = false;
            }
        }
        
    }
}
