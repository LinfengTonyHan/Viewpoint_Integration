using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExitTrigger6 : MonoBehaviour
{
    private City_Manager_6 cityManager; // Talk to the main script

    private void Awake()
    {
        cityManager = FindObjectOfType<City_Manager_6>();
    }

    private void OnTriggerEnter(Collider other)
    {
        cityManager.navigationEnd();
    }
}
