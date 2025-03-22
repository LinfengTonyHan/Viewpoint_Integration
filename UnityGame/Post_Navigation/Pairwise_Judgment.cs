using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;

public class Pairwise_Judgment : MonoBehaviour
{
    [Header("Texts")]
    public Text startText; // instructions
    public Text questionText; // main question
    public Text endText; // session end text

    [Header("Image Stimuli")]
    public Image store1; // storefront on the left
    public Image store2; // storefront on the right
    public Image[] storeSet1; // The first set of stores to be presented (for store1)
    public Image[] storeSet2; // The second set of stores to be presented (for store2)

    [Header("Choice Buttons")]
    public Button streetChoice;
    public Button buildingChoice;
    public Button neitherChoice;

    private int[] facade_Seq = { 2, 20, 17, 6, 7, 4, 24, 13, 5, 3, 14, 22, 23, 8, 11, 18, 15, 21, 19, 16, 10, 12, 9, 1 };

    private int[] storeA = { 9, 14, 21, 2, 1, 8, 17, 11, 22, 23, 16, 2, 3, 6, 19, 9, 17, 16 };
    private int[] storeB = { 10, 13, 4, 8, 2, 7, 18, 12, 21, 24, 14, 9, 4, 5, 20, 13, 6, 15 };
    private int facadeIDA;
    private int facadeIDB;
    private int trialIndex = 0;

    private int targetIDA;
    private int targetIDB;

    private int trialNum = 18;
    private bool testingStart;
    private bool testingEnd;
    private int[] correctAnswerList = {1, 2, 0, 0, 1, 2, 1, 1, 2, 1, 0, 0, 2, 1, 2, 0, 0, 2, -1}; // The last (-1) prevents from exceeding the array bound

    private string next_scene_name = "DVIM_JRD_Final";

    // Start is called before the first frame update
    void Start()
    {
        Cursor.visible = true;

        startText.enabled = true;
        questionText.enabled = false;
        endText.enabled = false;
        store1.enabled = false;
        store2.enabled = false;
        streetChoice.enabled = false;
        buildingChoice.enabled = false;
        neitherChoice.enabled = false;

        streetChoice.SetGOActive(false);
        buildingChoice.SetGOActive(false);
        neitherChoice.SetGOActive(false);

        testingStart = false;
        testingEnd = false;

        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS), Choice, Choice index, Correct answer");
        EventLogger.Instance.LogEvent("Pairwise judgment test started," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.S))
        {
            testingStart = true;
        }
        // Update the sprites of the stimuli
        if (trialIndex < trialNum)
        {
            targetIDA = storeA[trialIndex];
            facadeIDA = facade_Seq[targetIDA - 1];
            store1.sprite = storeSet1[facadeIDA - 1].sprite;

            targetIDB = storeB[trialIndex];
            facadeIDB = facade_Seq[targetIDB - 1];
            store2.sprite = storeSet2[facadeIDB - 1].sprite;
        }    

        if (trialIndex == trialNum)
        {
            testingEnd = true;
        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            EventLogger.Instance.LogEvent("Quitted the pairwise judgment task to the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
            SceneManager.LoadScene("DVIM_Main_Menu");
        }


        if (Input.GetKeyDown(KeyCode.N))
        {
            if (testingEnd)
            {
                EventLogger.Instance.LogEvent("Pairwise judgment test ended," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
                SceneManager.LoadScene(next_scene_name);
            }

        }

            if (testingStart) // After the S key is pressed
        {
            startText.enabled = false;
            endText.enabled = false;

            questionText.enabled = true;
            store1.enabled = true;
            store2.enabled = true;
            streetChoice.enabled = true;
            buildingChoice.enabled = true;
            neitherChoice.enabled = true;

            // Make these buttons visible (disabling the button only disables the press, not the whole image)
            streetChoice.SetGOActive(true);
            buildingChoice.SetGOActive(true);
            neitherChoice.SetGOActive(true);
        }

        if (testingEnd) // When the session reaches the end
        {
            endText.enabled = true;

            startText.enabled = false;
            questionText.enabled = false;
            store1.enabled = false;
            store2.enabled = false;
            streetChoice.enabled = false;
            buildingChoice.enabled = false;
            neitherChoice.enabled = false;

            // Make these buttons visible (disabling the button only disables the press, not the whole image)
            streetChoice.SetGOActive(false);
            buildingChoice.SetGOActive(false);
            neitherChoice.SetGOActive(false);
        }
    }

    public void Choice_SameStreet()
    {
        EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "Same street, 1," + correctAnswerList[trialIndex].ToString());
        trialIndex++;
        // Refresh the button visibly
        streetChoice.enabled = false;
        streetChoice.enabled = true;
    }

    public void Choice_SameBuilding()
    {
        EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "Same building, 2," + correctAnswerList[trialIndex].ToString());
        trialIndex++;
        // Refresh the button visibly
        buildingChoice.enabled = false;
        buildingChoice.enabled = true;  
    }

    public void Choice_Neither()
    {
        EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "Neither, 0," + correctAnswerList[trialIndex].ToString());
        trialIndex++;
        // Refresh the button visibly
        neitherChoice.enabled = false;
        neitherChoice.enabled = true;
    }

}
