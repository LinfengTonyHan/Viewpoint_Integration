using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MySceneRecorder;
using MyUtility;

public class GeneratePositions : MonoBehaviour
{
    GameObject facade1;
    GameObject facade2;
    private string facade1Name;
    private string facade2Name;

    // Start is called before the first frame update
    void Start()
    {
        EventLogger.Instance.LogEvent("Facade ID, position X, position Z, Rotation Y");

        for (int i = 1; i <= 12; i++)
        {
            facade1Name = "P" + i.ToString() + "F1";
            facade2Name = "P" + i.ToString() + "F2";
            facade1 = GameObject.Find(facade1Name);
            facade2 = GameObject.Find(facade2Name);
            EventLogger.Instance.LogEvent(facade1Name + "," + facade1.transform.position.x.ToString() + "," +
                facade1.transform.position.z.ToString() + "," + facade1.transform.eulerAngles.y.ToString());
            EventLogger.Instance.LogEvent(facade2Name + "," + facade2.transform.position.x.ToString() + "," +
                facade2.transform.position.z.ToString() + "," + facade2.transform.eulerAngles.y.ToString());
        }

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
