﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityStandardAssets.Characters.FirstPerson;
using MySceneRecorder;
using MyUtility;

public class City_Manager_1 : MonoBehaviour
{
    public GameObject participant;

    public float moveSpeed = 12; // move speed in the guided navigation mode
    public float turnSpeed = 36; // head turn speed in the free navigation mode
    public float mode = 1; // mode: 1-Guided navigation mode, with a fixed route; 2-free navigation mode
    public float moveSpeedView = 3.2f;
    public float moveSpeedView_SameBuilding = 5;
    public float viewTime = 2; // The time for viewing each facade

    public GameObject mainPanel;
    public GameObject[] facadesAll;
    public Material[] facadeMaterials;

    public loadSeq facadeSequenceGenerator;
    private int[] facade_ID;

    // private int[] facade_ID = { 2, 20, 17, 6, 7, 4, 24, 13, 5, 3, 14, 22, 23, 8, 11, 18, 15, 21, 19, 16, 10, 12, 9, 1 };
    // The moving speed when approaching the storefront
    // private float turnSpeedView = 30;

    private FirstPersonController fps;

    private int facadeIndex = 1;
    private float curTime = 0;
    private float stopTime = 0.5F; // Same-street viewing: stop in the middle to make the time interval consistently at 7s

    private float collisionTime = 0;

    private bool navEnd;
    private string next_scene_name = "DVIM_City_Main_2"; // Change this in the new version

    // Make sure that each row (except the first row) consists of one movement
    private string[] moveMethods =
        new string[] { "turn", // Make observations of directions at the beginning
                       "movZ", "turn", "movX", "turn", "movZ", // From starting point to facades 1A & 1B
                       "mZnT", "view", "turn", "stop", "turn", "view", "turn", // View facades 1A & 1B
                       "movZ", "turn", "movX", "turn", "movZ", "turn", "movX", // From facades 1A & 1B to facades 2A & 2B
                       "mXnT", "view", "mXnV", "mZnV", "mZnT", "view", "turn", // View facades 2A & 2B
                       "movZ", "turn", "movX", // From facades 2A & 2B to facades 3A & 3B
                       "mXnT", "view", "turn", "stop", "turn", "view", "turn", // View facades 3A & 3B
                       "movX", "turn", "movZ", "turn", "movX", // From facades 3A & 3B to facades 4A & 4B
                       "mXnT", "view", "mXnV", "mZnV", "mZnT", "view", "turn", // View facades 4A & 4B
                       "movZ", "turn", "movX", "turn", "movZ", // From facades 4A & 4B to facades 5A & 5B
                       "mZnT", "view", "turn", "stop", "turn", "view", "turn", // View facades 5A & 5B
                       "movZ", "turn", "movX", // From facades 5A & 5B to facades 6A & 6B
                       "mXnT", "view", "turn", "stop", "turn", "view", "turn", // View facades 6A & 6B
                       "movX", "turn", "movZ", // From facades 6A & 6B to facades 7A & 7B
                       "mZnT", "view", "mZnV", "mXnV", "mXnT", "view", "turn", // View facades 7A & 7B
                       "movX", "turn", "movZ", // From facades 7A & 7B to facades 8A & 8B
                       "mZnT", "view", "mZnV", "mXnV", "mXnT", "view", "turn", // View facades 8A & 8B
                       "movX", "turn", "movZ", "turn", "movX", // From facades 8A & 8B to facades 9A & 9B
                       "mXnT", "view", "turn", "stop", "turn", "view", "turn", // View facades 9A & 9B
                       "movX", "turn", "movZ", "turn", "movX", // From facades 9A & 9B to facades 10A & 10B
                       "mXnT", "view", "mXnV", "mZnV", "mZnT", "view", "turn", // View facades 10A & 10B
                       "movZ", "turn", "movX", // From facades 10A & 10B to facades 11A & 11B
                       "mXnT", "view", "mXnV", "mZnV", "mZnT", "view", "turn", // View facades 11A & 11B
                       "movZ", "turn", "movX", "turn", "movZ", // From facades 11A & 11B to facades 12A & 12B
                       "mZnT", "view", "turn", "stop", "turn", "view", "turn", // View facades 12A & 12B
                       "movZ", "turn", "movX", "turn", "movZ" // From facades 12A & 12B -> Ending module
                     };

    private float[] positionX =
        new float[] { 95, 95, // direction observation
                      95, 95, 24, 24, 24, // start -> facades 1AB
                      24, 24, 24, 24, 24, 24, 24, // view facades 1AB
                      24, 24, 47, 47, 47, 47, 49, // 1AB -> 2AB
                      57, 57, 71, 71, 71, 71, 71, // view 2AB
                      71, 71, 128, // 2AB -> 3AB
                      136, 136, 136, 136, 136, 136, 136, // view 3AB
                      150, 150, 150, 150, 170, // 3AB -> 4AB
                      178, 178, 190, 190, 190, 190, 190, // view 4AB
                      190, 190, 150, 150, 150, // 4AB -> 5AB
                      150, 150, 150, 150, 150, 150, 150, // view 5AB
                      150, 150, 43, // 5AB -> 6AB
                      35, 35, 35, 35, 35, 35, 35, // view 6AB
                      24, 24, 24, // 6AB -> 7AB
                      24, 24, 24, 29, 37, 37, 37, // view 7AB
                      71, 71, 71, // 7AB -> 8AB
                      71, 71, 71, 74, 82, 82, 82, // view 8AB
                      95, 95, 95, 95, 111, // 8AB -> 9AB
                      119, 119, 119, 119, 119, 119, 119, // view 9AB
                      134, 134, 134, 134, 171, // 9AB -> 10AB
                      179, 179, 190, 190, 190, 190, 190, // view 10AB
                      190, 190, 170, // 10AB -> 11AB
                      162, 162, 150, 150, 150, 150, 150, // view 11AB
                      150, 150, 126, 126, 126, // 11AB -> 12AB
                      126, 126, 126, 126, 126, 126, 126, // view 12AB
                      126, 126, 95, 95, 95 // 12AB -> End
                    };

    private float[] positionZ =
        new float[]  { 68, 68, // direction observation
                       20, 20, 20, 20, 26, // start -> facades 1AB
                       34, 34, 34, 34, 34, 34, 34, // view facades 1AB
                       44, 44, 44, 44, 68, 68, 68, // 1AB -> 2AB
                       68, 68, 68, 67, 59, 59, 59, // view 2AB
                       44, 44, 44, // 2AB -> 3AB
                       44, 44, 44, 44, 44, 44, 44, // view 3AB
                       44, 44, 20, 20, 20, // 3AB -> 4AB
                       20, 20, 20, 23, 31, 31, 31, // view 4AB
                       57, 57, 57, 57, 58, // 4AB -> 5AB
                       66, 66, 66, 66, 66, 66, 66, // view 5AB
                       99, 99, 99, // 5AB -> 6AB
                       99, 99, 99, 99, 99, 99, 99, // view 6AB
                       99, 99, 129, // 6AB -> 7AB
                       137, 137, 147, 147, 147, 147, 147, // view 7AB
                       147, 147, 143, // 7AB -> 8AB
                       135, 135, 123, 123, 123, 123, 123, // view 8AB
                       123, 123, 68, 68, 68, // 8AB -> 9AB
                       68, 68, 68, 68, 68, 68, 68, // view 9AB
                       68, 68, 99, 99, 99, // 9AB -> 10AB
                       99, 99, 99, 103, 111, 111, 111, // view 10AB
                       147, 147, 147, // 10AB -> 11AB
                       147, 147, 147, 144, 136, 136, 136, // view 11AB
                       123, 123, 123, 123, 130, // 11AB -> 12AB
                       138, 138, 138, 138, 138, 138, 138, // view 12AB
                       147, 147, 147, 147, 68 // 12AB -> End
                     };

    // This variable, turnDirection, is one size shorter than the other variables
    // It only denotes the turning direction of the subsequent step
    private float[] turnDirection =
        new float[] { 360, // direction observation
                      0, 90, 0, 90, 0, // start -> facades 1AB
                      -90, 0, 90, 0, 90, 0, -90, // view facades 1AB
                      0, 90, 0, -90, 0, 90, 0, // 1AB -> 2AB
                      90, 0, 0, 0, 90, 0, -90, // view 2AB
                      0, -90, 0, // 2AB -> 3AB
                      90, 0, -90, 0, -90, 0, 90, // view 3AB
                      0, 90, 0, -90, 0, // 3AB -> 4AB
                      -90, 0, 0, 0, -90, 0, 90, // view 4AB
                      0, -90, 0, 90, 0, // 4AB -> 5AB
                      90, 0, -90, 0, -90, 0, 90, // view 5AB
                      0, -90, 0, // 5AB -> 6AB
                      -90, 0, 90, 0, 90, 0, -90, // view 6AB
                      0, 90, 0, // 6AB -> 7AB
                      90, 0, 0, 0, 90, 0, -90, // view 7AB
                      0, 90, 0, // 7AB -> 8AB
                      -90, 0, 0, 0, -90, 0, 90, // view 8AB
                      0, 90, 0, -90, 0, // 8AB -> 9AB
                      -90, 0, 90, 0, 90, 0, -90, // view 9AB
                      0, -90, 0, 90, 0, // 9AB -> 10AB
                      -90, 0, 0, 0, -90, 0, 90, // view 10AB
                      0, -90, 0, // 10AB -> 11AB
                      -90, 0, 0, 0, -90, 0, 90, // view 11AB
                      0, 90, 0, 90, 0, // 11AB -> 12AB
                      -90, 0, 90, 0, 90, 0, -90, // view 12AB
                      0, -90, 0, -90, 0 // 12AB -> End
                    };

    // curHeading is calculated based on turnDirection, but I still manually coded it...
    private float[] curHeading =
        new float[] { 180, 180, // direction observation
                      180, 270, 270, 0, 0, // start -> facades 1AB
                      270, 270, 0, 0, 90, 90, 0, // view facades 1AB
                      0, 90, 90, 0, 0, 90, 90, // 1AB -> 2AB
                      180, 180, 180, 180, 270, 270, 180, // view 2AB
                      180, 90, 90, // 2AB -> 3AB
                      180, 180, 90, 90, 0, 0, 90, // view 3AB 
                      90, 180, 180, 90, 90, // 3AB -> 4AB
                      0, 0, 0, 0, 270, 270, 0, // view 4AB
                      0, 270, 270, 0, 0, // 4AB -> 5AB
                      90, 90, 0, 0, 270, 270, 0, // view 5AB
                      0, 270, 270, // 5AB -> 6AB
                      180, 180, 270, 270, 0, 0, 270, // view 6AB
                      270, 0, 0, // 6AB -> 7AB
                      90, 90, 90, 90, 180, 180, 90, // view 7AB
                      90, 180, 180, // 7AB -> 8AB
                      90, 90, 90, 90, 0, 0, 90, // view 8AB
                      90, 180, 180, 90, 90, // 8AB -> 9AB
                      0, 0, 90, 90, 180, 180, 90, // view 9AB
                      90, 0, 0, 90, 90, // 9AB -> 10AB
                      0, 0, 0, 0, 270, 270, 0, // view 10AB
                      0, 270, 270, // 10AB -> 11AB
                      180, 180, 180, 180, 90, 90, 180, // view 11AB
                      180, 270, 270, 0, 0, // 11AB -> 12AB
                      270, 270, 0, 0, 90, 90, 0, // view 12AB
                      0, 270, 270, 180, 180 // 12AB -> End
                    };

    private float[] time = new float[200]; // Time points, in equal length to the events (e.g., moveMethods)
    //private float[] curHeading = new float[100];
    private float checkPoint = (float)0.01; // a time window to align the actual transform to the designated one


    // Start is called before the first frame update
    void Start()
    {
        facade_ID = facadeSequenceGenerator.facadeSequence;
        print(facade_ID[1]);
        Cursor.visible = false;

        EventLogger.Instance.LogEvent("Event, Empty, Time Stamp");
        fps = participant.GetComponent<FirstPersonController>();
        fps.enabled = false;
        mainPanel.SetActive(false); // The end panel is inactivated until the end of the navigation
        participant.transform.position = new Vector3(95, (float)1.5, 68); // Starting point
        participant.transform.eulerAngles = new Vector3(0, 180, 0);
        time[0] = 0; // At the beginning: Time = 0;

        navEnd = false;

        // Randomization of facades across the whole city
        // Each participant has a unique sequence
        for (int i = 0; i < 24; i++)
        {
            facadesAll[i].GetComponent<MeshRenderer>().material = facadeMaterials[facade_ID[i] - 1];
        }
        EventLogger.Instance.LogEvent("Facade materials successfully loaded, -, -");
    }

    // Update is called once per frame
    void Update()
    {
        // Quit the scene if the participant presses "escape"
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene("DVIM_Main_Menu");
            EventLogger.Instance.LogEvent("Quitted the first navigation session and accessed the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
        }

        if (Input.GetKeyDown(KeyCode.N))
        {
            if (navEnd)
            {
                EventLogger.Instance.LogEvent("Finished the first navigation session," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
                SceneManager.LoadScene(next_scene_name);
            }
        }

        // Remove the skip feature
        // if (Input.GetKeyDown(KeyCode.Alpha0))
        // {
        //    EventLogger.Instance.LogEvent("Skipped the navigation session 1," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -, -");
        //    SceneManager.LoadScene(next_scene_name);
        // }

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
                time[timePoint + 1] = moveParticipant(moveMethods[timePoint], timePoint, time[timePoint]); // Calling the function every frame? Look okay...
            }
        }

        // Free navigation mode
        else if (mode == 2)
        {
            fps.enabled = true;
        }

       if (collisionTime == 2)
        {
            collisionReach();
        }
    }

    // Move the participant
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

        // mXnV: slowly move on the x-axis to ensure a good view: used only in between two facades on the same building
        else if (method == "mXnV")
        {
            float endP = positionX[timeStamp + 1]; // endpoint: next x-coordinate in the array
            float startP = positionX[timeStamp]; // startpoint: current x-coordinate in the array

            float dist = Mathf.Abs(endP - startP); // distance
            float endT = startT + dist / moveSpeedView_SameBuilding; // end time (and will be returned as the output)

            if ((curTime >= startT + checkPoint) & (curTime <= endT - checkPoint))
            {
                // Moving forward: translating the z-axis (moving forward), not the x-axis
                // participant.transform.Translate(new Vector3(0, 0, moveSpeed) * Time.deltaTime);
                if (endP < startP)
                {
                    participant.transform.position = participant.transform.position - new Vector3(moveSpeedView_SameBuilding, 0, 0) * Time.deltaTime;
                }
                else if (endP > startP)
                {
                    participant.transform.position = participant.transform.position + new Vector3(moveSpeedView_SameBuilding, 0, 0) * Time.deltaTime;
                }

            }
            
            return endT;
        }

        // mZnV: slowly move on the z-axis to ensure a good view: used only in between two facades on the same building
        else if (method == "mZnV")
        {
            float endP = positionZ[timeStamp + 1];
            float startP = positionZ[timeStamp];

            float dist = Mathf.Abs(endP - startP);
            float endT = startT + dist / moveSpeedView_SameBuilding;

            if ((curTime >= startT + checkPoint) & (curTime <= endT - checkPoint))
            {
                // Moving forward: translating the z-axis (moving forward)
                // participant.transform.Translate(new Vector3(0, 0, moveSpeed) * Time.deltaTime);
                if (endP < startP)
                {
                    participant.transform.position = participant.transform.position - new Vector3(0, 0, moveSpeedView_SameBuilding) * Time.deltaTime;
                }
                else if (endP > startP)
                {
                    participant.transform.position = participant.transform.position + new Vector3(0, 0, moveSpeedView_SameBuilding) * Time.deltaTime;
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
            // There shouldn't be any methods other than the above -- if there is, report an error
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

    // Used to interact with the other script... Ending the navigation session
    public void navigationEnd()
    {
        collisionTime++;
    }

    private void collisionReach()
    {
        mainPanel.SetActive(true);
        navEnd = true;
        Debug.Log("Collider entered and session ended");
        for (int i = 0; i < 200; i++)
        {
            EventLogger.Instance.LogEvent("Navigation time stamp," + "-, " + time[i].ToString());
        }
    }

}
