using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExitTrigger5 : MonoBehaviour
{
    private City_Manager_5 cityManager; // Talk to the main script

    private void Awake()
    {
        cityManager = FindObjectOfType<City_Manager_5>();
    }

    private void OnTriggerEnter(Collider other)
    {
        cityManager.navigationEnd();
    }
}
