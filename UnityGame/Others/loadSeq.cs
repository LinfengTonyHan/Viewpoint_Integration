using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class loadSeq : MonoBehaviour
{
    // facadeSequence is the variable accessed by the main function
    public int[] facadeSequence = { 14, 5, 24, 21, 16, 9, 11, 22, 3, 1, 7, 15, 20, 12, 17, 6, 2, 19, 10, 8, 4, 13, 23, 18 }; // Sequence for participant #011

    private int[] innerControl = { 14, 5, 24, 21, 16, 9, 11, 22, 3, 1, 7, 15, 20, 12, 17, 6, 2, 19, 10, 8, 4, 13, 23, 18 }; 
    // Start is called before the first frame update
    private void Start()
    {
        facadeSequence = innerControl;
    }
}
