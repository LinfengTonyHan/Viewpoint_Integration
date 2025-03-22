using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;
using System;

public class JRD_1 : MonoBehaviour
{
    public Image targetImage; // The image to judge
    public Text instructionText;
    public Text landmarkText;
    public Text instructionBegin;
    public Text instructionEnd;
    public Text questionNumber;
    // Texture2D tex; // Texture of the faced image

    public Image[] stimuli; // The array that stores all the stimuli
    // string filePath = "/Users/linfenghan/Dropbox (Epstein Lab)/Epstein Lab Team Folder/TonyHan/Project-DVIM/Unity_Environment/DVIM-City/Assets/Storefront_Testing/JRD_S01";

    private int firstTrialTime = 8;
    private int regularTrialTime = 6;

    private int trialNum = 24;
    private int trialIndex;
    public loadSeq facadeSequenceGenerator;
    private int[] facade_ID; // The facade_ID sequence is loaded

    private float[] headDir = { 270, 90, 180, 270, 180, 0, 0, 270, 90, 270, 180, 0, 90, 180, 90, 0, 0, 180, 0, 270, 180, 90, 270, 90 };// the heading directions of the participant when looking at the 24 facades (in facade_ID)

    // Specific to the first JRD block
    private int[] JRD_Target_ID = { 22, 6, 3, 16, 11, 7, 17, 14, 8, 5, 21, 19, 15, 1, 23, 2, 4, 18, 24, 13, 9, 20, 10, 12 }; // a random trial sequence (see stored file)

    private int[] landmark_ID = { 1, 2, 3, 4, 3, 1, 2, 3, 4, 1, 2, 4, 3, 1, 2, 1, 2, 4, 3, 3, 4, 1, 2, 4 }; // a random trial sequence (see stored file)

    private int[] correctAnswer = new int[24]; // Correct answers will be updated throughout the experiment

    private int facadeIndex;
    private int targetIndex;
    private int landmarkIndex;
    private string landmarkName;

    private bool testingStart; // when the S key is pressed, the testing would start.
    private bool testingEnd;
    private float y_rot;
    private float headingDiff;
    private float curTime = 0;

    private string next_scene_name = "DVIM_City_Main_6";

    // Start is called before the first frame update
    void Start()
    {
        facade_ID = facadeSequenceGenerator.facadeSequence;
        print(facade_ID[0]);

        testingStart = false;
        trialIndex = 0;
        // tex = new Texture2D(2, 2);
        targetImage.enabled = false;
        instructionText.enabled = false;
        landmarkText.enabled = false;
        instructionBegin.enabled = true;
        instructionEnd.enabled = false;
        questionNumber.enabled = false;

        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS), Trial Number, Sequence ID, Facade ID, Landmark ID, Response, Correct Answer"); // Header
        // Text of the instruction

        // fileName = filePath + "/" + fileIndex.ToString() + ".jpeg";

        // imageByte = File.ReadAllBytes(fileName);

        // print(imageByte);
        // tex.LoadImage(imageByte);
        // targetImage.texture = tex;
    }

    // Update is called once per frame
    void Update()
    {

        if (testingStart)
        {
            curTime = curTime + Time.deltaTime;
            if (curTime < firstTrialTime)
                trialIndex = 0;
            else if (curTime >= firstTrialTime)
                trialIndex = (int)Math.Floor((curTime - (firstTrialTime - regularTrialTime)) / regularTrialTime);

            landmarkText.enabled = true; // visualize the landmark text
            instructionText.enabled = true; // keep the instructions visible
            targetImage.enabled = true;
            questionNumber.enabled = true;
            instructionBegin.enabled = false;
            instructionEnd.enabled = false;

            instructionText.text = "Imagine yourself standing in front of the store above and directly facing the store. "
            + "Please use the keys 7, 8, 9, and 0 to indicate the direction of the following landmark:"
            + "\n\n\n"
            + "When you face this store, if you think the landmark is on the left-hand side, press 7; \n"
            + "When you face this store, if you think the landmark is on the right-hand side, press 0; \n"
            + "When you face this store, if you think the landmark is in front of you, press 8; \n"
            + "When you face this store, if you think the landmark is behind you, press 9. \n";
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            if (trialIndex == 0) // If at the beginning of this testing session
            {
                testingStart = true;
                // gotoNextQuestion();
            }
        }

        if (trialIndex == (trialNum)) // If at the end of this testing session
        {
            testingEnd = true;
        }

        if (testingEnd)
        {
            landmarkText.enabled = false; // visualize the landmark text
            instructionText.enabled = false; // keep the instructions visible
            targetImage.enabled = false;
            instructionBegin.enabled = false;
            questionNumber.enabled = false;
            instructionEnd.enabled = true;
        }

        if (Input.GetKeyDown(KeyCode.N))
        {
            if (testingEnd) // If at the end of this testing session, press N to proceed
            {
                EventLogger.Instance.LogEvent("1st JRD test completed," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -, -, -, -");
                SceneManager.LoadScene(next_scene_name);
            }
        }

        // Go to the main menu
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            EventLogger.Instance.LogEvent("Quitted the final JRD test to the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -, -, -, -");
            SceneManager.LoadScene("DVIM_Main_Menu");
        }

        if (Input.GetKeyDown(KeyCode.Alpha9) && testingStart && trialIndex < trialNum) // Back
        {
            EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") +
                (trialIndex + 1).ToString() + "," + targetIndex.ToString() + "," + facadeIndex.ToString() + "," + landmarkName + ", 2," + correctAnswer[trialIndex]); // 2: back
        }

        else if (Input.GetKeyDown(KeyCode.Alpha0) && testingStart && trialIndex < trialNum) // Right
        {
            EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") +
                (trialIndex + 1).ToString() + "," + targetIndex.ToString() + "," + facadeIndex.ToString() + "," + landmarkName + ", 4," + correctAnswer[trialIndex]); // 4: right
        }

        else if (Input.GetKeyDown(KeyCode.Alpha7) && testingStart && trialIndex < trialNum) // Left
        {
            EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") +
                (trialIndex + 1).ToString() + "," + targetIndex.ToString() + "," + facadeIndex.ToString() + "," + landmarkName + ", 3," + correctAnswer[trialIndex]); // 3: left
        }

        else if (Input.GetKeyDown(KeyCode.Alpha8) && testingStart && trialIndex < trialNum) // Front
        {
            EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") +
                (trialIndex + 1).ToString() + "," + targetIndex.ToString() + "," + facadeIndex.ToString() + "," + landmarkName + ", 1," + correctAnswer[trialIndex]); // 1: front
        }

        questionNumber.text = "Question: " + (trialIndex + 1).ToString() + " / 24";

        if (trialIndex < trialNum)
        {
            targetIndex = JRD_Target_ID[trialIndex];
            landmarkIndex = landmark_ID[trialIndex];
            facadeIndex = facade_ID[targetIndex - 1]; // Load the specific facade (based on the unique facade ID sequence for this participant)

            print(facadeIndex);
            targetImage.sprite = stimuli[facadeIndex - 1].sprite;

            y_rot = headDir[targetIndex - 1];

            if (landmarkIndex == 1)
            {
                landmarkName = "The Mountain"; // The Mountain is at heading direction = 270
            }
            else if (landmarkIndex == 2)
            {
                landmarkName = "The Lighthouse";
            }

            else if (landmarkIndex == 3)
            {
                landmarkName = "The Tower";
            }

            else if (landmarkIndex == 4)
            {
                landmarkName = "The Bridge";
            }

            landmarkText.text = landmarkName;

            headingDiff = y_rot - landmarkIndex * 90 + 540;

            if (headingDiff % 360 == 0)
            {
                correctAnswer[trialIndex] = 1; // front
            }

            else if (headingDiff % 360 == 90)
            {
                correctAnswer[trialIndex] = 3; // left
            }

            else if (headingDiff % 360 == 180)
            {
                correctAnswer[trialIndex] = 2; // back
            }

            else if (headingDiff % 360 == 270)
            {
                correctAnswer[trialIndex] = 4; // right
            }

        }


    }

}
