using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExitTrigger2 : MonoBehaviour
{
    private City_Manager_2 cityManager; // Talk to the main script

    private void Awake()
    {
        cityManager = FindObjectOfType<City_Manager_2>();
    }

    private void OnTriggerEnter(Collider other)
    {
        cityManager.navigationEnd();
    }
}
