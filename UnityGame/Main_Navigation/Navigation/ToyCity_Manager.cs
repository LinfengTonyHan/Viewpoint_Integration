using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityStandardAssets.Characters.FirstPerson;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;


public class ToyCity_Manager : MonoBehaviour
{
    public GameObject participant;
    
    public int mode;
    public Text onScreenText;
    public Text instructionEnd;
    
    public GameObject mainPanel;
    private float moveSpeedView = 4;
    
    // private float turnSpeedView = 30;

    private FirstPersonController fps;

    private float curTime = 0;
    private float turnSpeed = 45; // head turn speed in the free navigation mode
    private float viewTime = 3; // The time for viewing each facade
                                // private int nStep = 100;
    private float moveSpeed = 15; // Not using this variable here.
    private float stopTime = 0.5f; // Not using this variable here.
    private float turnTime;
    private float timeTotal;
    
    private bool navigationEnd;

    private string[] landmarkList = { "The Mountain", "The Lighthouse", "The Tower", "The Bridge" };
    private string next_scene_name = "DVIM_City_Main_Instruction";

    // Make sure that each row (except the first row) consists of one movement
    private string[] moveMethods =
        new string[] { "view",
                       "turn", "view", "turn", "view", "turn", "view", "turn", "view", // First group of viewing: CW
                       "turn", "view", "turn", "view", "turn", "view", "turn", "view" // Second group of viewing: CCW
                     };

    private float[] positionX =
        new float[] { 95,
                      95, 95, 95, 95, 95, 95, 95, 95,
                      95, 95, 95, 95, 95, 95, 95, 95
                    };

    private float[] positionZ =
        new float[] { 68,
                      68, 68, 68, 68, 68, 68, 68, 68,
                      68, 68, 68, 68, 68, 68, 68, 68
                    };

    // This variable, turnDirection, is one size shorter than the other variables
    // It only denotes the turning direction of the subsequent step
    private float[] turnDirection =
        new float[] {0,
                     90, 0, 90, 0, 90, 0, 90, 0,
                     -90, 0, -90, 0, -90, 0, -90, 0
                    };

    private float[] curHeading =
        new float[] {270, 
                     270,
                     0, 0, 90, 90, 180, 180, 270, 270,
                     180, 180, 90, 90, 0, 0, 270, 270
                    };

    private float[] time = new float[200]; // Time points
    private float checkPoint = (float)0.01; // a time window to align the actual transform to the designated onea
   

    // Start is called before the first frame update
    void Start()
    {
        Cursor.visible = false;

        turnTime = 90 / turnSpeed;
        timeTotal = turnTime * 8 + viewTime * 9;
        mainPanel.SetActive(false);
        navigationEnd = false;
        instructionEnd.enabled = true;
        fps = participant.GetComponent<FirstPersonController>();
        fps.enabled = false;
        participant.transform.position = new Vector3(95, (float)1.5, 68); // Starting position
        time[0] = 0; // At the beginning: Time = 0

        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS)");
        EventLogger.Instance.LogEvent("Started toy city viewing," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
    }

    // Update is called once per frame
    void Update()
    {

    // Quit the scene if the participant presses "escape"
    if (Input.GetKeyDown(KeyCode.Escape))
    {
        SceneManager.LoadScene("DVIM_Main_Menu");
        EventLogger.Instance.LogEvent("Exited to the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
    }

    if (Input.GetKeyDown(KeyCode.N))
    {
        if (navigationEnd)
            {
                EventLogger.Instance.LogEvent("Navigation ended and entered the main city instruction," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff"));
                SceneManager.LoadScene(next_scene_name);                
            }
    }

    // Guided navigation mode
    if (mode == 1)
    // Record the current time
    {
        curTime = curTime + Time.deltaTime;

        // Trajectories
        for (int timePoint = 0; timePoint < (positionX.Length - 1); timePoint++)
        {
            // Correct the transform to the start point to avoid mini-errors in subsequent movements
            correctTransform(timePoint, positionX[timePoint], positionZ[timePoint]);
            time[timePoint + 1] = moveParticipant(moveMethods[timePoint], timePoint, time[timePoint]);
        }
    }
    // Free navigation mode
        else if (mode == 2)
        {
            fps.enabled = true;
        }

    float realHeading = participant.transform.eulerAngles.y;
    displayInst(realHeading);

    print(participant.transform.eulerAngles.y);

        if (curTime > timeTotal)
        {
            navigationEnd = true;
        }

        if (navigationEnd)
        {
            mainPanel.SetActive(true);
            instructionEnd.enabled = true;
            onScreenText.enabled = false;
        }
    }

    void displayInst(float HD)
    {
        // onScreenText.enabled = true;
        string inst = "Now you are facing:\n";
        string displayedText = "";
        if ((HD%360 < 290) && (HD%360 > 250))
        {
            onScreenText.enabled = true;
            displayedText = inst + landmarkList[0];
        }

        else if ((HD%360 < 20) || (HD%360 > 340))
        {
            onScreenText.enabled = true;
            displayedText = inst + landmarkList[1];
        }

        else if ((HD%360 < 110) && (HD%360 > 70))
        {
            onScreenText.enabled = true;
            displayedText = inst + landmarkList[2];
        }

        else if ((HD%360 < 200) && (HD%360 > 160))
        {
            onScreenText.enabled = true;
            displayedText = inst + landmarkList[3];
        }

        else
        {
            onScreenText.enabled = false;
        }

        onScreenText.text = displayedText; // Update the landmark instruction
    }

float moveParticipant(string method, int timeStamp, float startT)
    {
        // movX: move the participant on the x-axis. Note that the z-transform will be adjusted (moving forward).
        if (method == "movX")
        {
            float endP = positionX[timeStamp + 1]; // endpoint: next x-coordinate in the array
            float startP = positionX[timeStamp]; // startpoint: current x-coordinate in the array

            float dist = Mathf.Abs(endP - startP); // distance
            float endT = startT + dist / moveSpeed; // end time (and will be returned as the output)

            if ((curTime >= startT + checkPoint) & (curTime <= endT - checkPoint))
            {
                // Moving forward: translating the z-axis (moving forward), not the x-axis
                // participant.transform.Translate(new Vector3(0, 0, moveSpeed) * Time.deltaTime);
                if (endP < startP)
                {
                    participant.transform.position = participant.transform.position - new Vector3(moveSpeed, 0, 0) * Time.deltaTime;
                }
                else if (endP > startP)
                {
                    participant.transform.position = participant.transform.position + new Vector3(moveSpeed, 0, 0) * Time.deltaTime;
                }

            }
            print(dist);
            return endT;
        }

        // movZ: move the participant on the z-axis
        else if (method == "movZ")
        {
            float endP = positionZ[timeStamp + 1];
            float startP = positionZ[timeStamp];

            float dist = Mathf.Abs(endP - startP);
            float endT = startT + dist / moveSpeed;

            if ((curTime >= startT + checkPoint) & (curTime <= endT - checkPoint))
            {
                // Moving forward: translating the z-axis (moving forward)
                // participant.transform.Translate(new Vector3(0, 0, moveSpeed) * Time.deltaTime);
                if (endP < startP)
                {
                    participant.transform.position = participant.transform.position - new Vector3(0, 0, moveSpeed) * Time.deltaTime;
                }
                else if (endP > startP)
                {
                    participant.transform.position = participant.transform.position + new Vector3(0, 0, moveSpeed) * Time.deltaTime;
                }

            }
            return endT;
        }

        else if (method == "turn")
        {
            float degree = turnDirection[timeStamp];
            float endT = startT + Mathf.Abs(degree / turnSpeed);
            float directionIdx = Mathf.Abs(degree) / degree;

            if ((curTime >= startT + checkPoint) & (curTime <= endT - checkPoint))
            {
                participant.transform.Rotate(0, turnSpeed * Time.deltaTime * directionIdx, 0);
            }
            return endT;
        }

        else if (method == "mXnT") //move X and turn: When the participant needs to view a storefront stimulus parallel to the x-axis
        {
            float endP = positionX[timeStamp + 1]; // endpoint: next x-coordinate in the array
            float startP = positionX[timeStamp]; // startpoint: current x-coordinate in the array

            float dist = Mathf.Abs(endP - startP); // distance
            float distIdx = (endP - startP) / dist;
            float degree = turnDirection[timeStamp];
            float directionIdx = Mathf.Abs(degree) / degree;
            float moveTime = dist / moveSpeedView;
            float endT = startT + moveTime; // end time (and will be returned as the output)
            float turnSpeedView = 90 / moveTime;
            if ((curTime >= startT + checkPoint) & (curTime <= endT - checkPoint))
            {
                participant.transform.position += new Vector3(moveSpeedView * distIdx, 0, 0) * Time.deltaTime; // Translating on the x-axis
                // participant.transform.Translate(new Vector3(0, 0, moveSpeed) * Time.deltaTime);
                participant.transform.eulerAngles += new Vector3(0, turnSpeedView * Time.deltaTime * directionIdx, 0);
                // participant.transform.Rotate(0, turnSpeedView * Time.deltaTime * directionIdx, 0);
            }

            // print(turnSpeedView);
            return endT;
        }

        else if (method == "mZnT") //move Z and turn: When the participant needs to view a storefront stimulus parallel to the z-axis
        {
            float endP = positionZ[timeStamp + 1]; // endpoint: next z-coordinate in the array
            float startP = positionZ[timeStamp]; // startpoint: current z-coordinate in the array

            float dist = Mathf.Abs(endP - startP); // distance
            float distIdx = (endP - startP) / dist;
            float degree = turnDirection[timeStamp];
            float directionIdx = Mathf.Abs(degree) / degree;
            float moveTime = dist / moveSpeedView;
            float endT = startT + moveTime; // end time (and will be returned as the output)
            float turnSpeedView = 90 / moveTime;
            if ((curTime >= startT + checkPoint) & (curTime <= endT - checkPoint))
            {
                participant.transform.position += new Vector3(0, 0, moveSpeedView * distIdx) * Time.deltaTime;
                // participant.transform.Translate(new Vector3(0, 0, moveSpeed) * Time.deltaTime);
                participant.transform.eulerAngles += new Vector3(0, turnSpeedView * Time.deltaTime * directionIdx, 0);
                // participant.transform.Rotate(0, turnSpeedView * Time.deltaTime * directionIdx, 0);
            }

            // print(turnSpeedView);
            return endT;
        }

        else if (method == "view")
        {
            float endT = startT + viewTime;

            return endT;
        }

        else if (method == "stop")
        {
            float endT = startT + stopTime;

            return endT;
        }

        else
        {
            // There shouldn't be any methods other than "movX" "movZ" and "turn" -- if there is, report an error
            print("Method incorrect!");
            float endT = 0;
            return endT;
        }

        
    }

    // There would be small errors (due to monitor refreshing) within each step, correct them after each movement
    void correctTransform(int timeStamp, float posX, float posZ)
    {
        // Leave a very small time window to correct the participant transform
        if (Mathf.Abs(curTime - time[timeStamp]) < checkPoint)
        {
            participant.transform.position = new Vector3(posX, (float)1.5, posZ);
            participant.transform.eulerAngles = new Vector3(0, curHeading[timeStamp], 0);
        }
    }

}
