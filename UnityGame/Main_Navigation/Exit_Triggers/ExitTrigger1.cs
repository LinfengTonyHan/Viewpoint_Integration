using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExitTrigger1 : MonoBehaviour
{
    private City_Manager_1 cityManager; // Talk to the main script

    private void Awake()
    {
        cityManager = FindObjectOfType<City_Manager_1>();
    }

    private void OnTriggerEnter(Collider other)
    {
        cityManager.navigationEnd();
    }
}
