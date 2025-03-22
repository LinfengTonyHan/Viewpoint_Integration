using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;

public class PTTA : MonoBehaviour
{
    [Header("Text")]
    public Text trialCount; // The current trial number
    public Text timeCount; // Showcase the time left
    public Text instructionEnd; // End of experiment instructions

    [Header("Main Question Board")]
    public Image mainQuestion; // Main image

    [Header("Stimuli")]
    public Image[] Instructions; // All instructional slides
    public Image[] practice_E1; // 8 possible responses to practice question 1
    public Image[] practice_E2; // 8 possible responses to practice question 2
    public Image[] practice_E3; // 8 possible responses to practice question 3
    public Image[] question_list; // Formal testing questions

    private float timeLeft = 180.0f;
    private bool answerPracticeQ;
    private int insIndex; // Index for instruction images: When it reaches 9, 11, 13 -- participants should be answering a practice question
    private bool lookAtResponse; // If participants are looking at their own response
    private bool formalTestingStart; // If participants have proceeded to the formal testing questions
    private bool formalTestingEnd;
    private int trialIndex;
    // Start is called before the first frame update
    void Start()
    {
        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS), Trial Number, Response");

        trialCount.enabled = false;
        timeCount.enabled = false;
        answerPracticeQ = false; // If the participant is looking at the practice questions (three practice questions in total)
        formalTestingStart = false; // If the formal testing questions have started
        formalTestingEnd = false;
        lookAtResponse = false; // If the participant is looking at their own response
        instructionEnd.enabled = false;
        insIndex = 0; // Instruction slide index

        mainQuestion.sprite = Instructions[insIndex].sprite; // The first slide of the instruction ("press the space bar to proceed")

        trialIndex = 0; // Formal testing trial number
    }

    // Update is called once per frame
    void Update()
    {
        // Basic Settings: Entering and and quitting the session //
        ///////////////////////////////////////////////////////////
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            EventLogger.Instance.LogEvent("Quitted the PTTA session to the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -");
            SceneManager.LoadScene("DVIM_Main_Menu");
        }

        if (formalTestingStart && trialIndex <= 31) // Formal testing trials begin -- update the sprite
        {
            trialCount.enabled = true;
            timeCount.enabled = true;
            mainQuestion.sprite = question_list[trialIndex].sprite; // The next image should be in the [question_list] sequence
            timeLeft = timeLeft - Time.deltaTime;

            trialCount.text = "Question number: " + (trialIndex + 1).ToString() + " / 32";
            timeCount.text = "Time Left: " + Convert.ToInt32(Math.Ceiling(timeLeft)).ToString();
        }

        else if (!formalTestingStart && insIndex <= 15 && !lookAtResponse) // Practice phase (!formalTestingStart && insIndex <= 15),
                                                                         // and the participant is not looking at their own response
                                                                         // (rather, is reading the instructions or looking at the correct answers)
        {
            mainQuestion.sprite = Instructions[insIndex].sprite; // The upcoming image should be in the [Instructions] sequence
        }

        if (trialIndex == 32 || timeLeft <= 0) // End the experiment
        {
            formalTestingEnd = true;
        }

        if (formalTestingEnd)
        {
            instructionEnd.enabled = true;
            trialCount.enabled = false;
            timeCount.enabled = false;
            mainQuestion.enabled = false;
        }


        if (Input.GetKeyDown(KeyCode.N))
        {
            if (formalTestingEnd)

            {
                EventLogger.Instance.LogEvent("PTTA ended; entered the image recognition test," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -");
                SceneManager.LoadScene("DVIM_Image_Recognition");
            }
        }

        //////////////////////////////////////////////////////////

        if (Input.GetKeyDown(KeyCode.Space)) // Space bar: proceeding through the instructions
        {

            if (!answerPracticeQ && !lookAtResponse && !formalTestingStart) // If not:
                                                                            // 1) looking at the practice question (answerPracticeQ),
                                                                            // 2) looking at their own response (lookAtAnswer),
                                                                            // 3) the formal testing hasn't started yet (Still in the practice phase)
                   
            {
                insIndex++; // Proceed to the next practice/instruction slide
            }

            else if (lookAtResponse && !formalTestingStart) // If looking at their own response (for which the images are in practice_E1/E2/E3)
            {
                insIndex++; // Proceed to the next practice/instruction slide (insIndex will become 10/12/14 to disable "answerPracticeQ")
                lookAtResponse = false; // After proceeding, lookAtResponse variable should be disabled
            }
        }

        if (insIndex == 9 || insIndex == 11 || insIndex == 13) // On these trials, the participant is looking at the practice questions
        {
            answerPracticeQ = true;
        }
        else
        {
            answerPracticeQ = false;
        }

        if (insIndex == 16) // After going through all the instructions, start the formal testing period
        {
            formalTestingStart = true;
        }


        // Recording the participant's response: Pressing 1
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            if (answerPracticeQ) // When the participant is making a response to one of the practice questions
            {
                if (insIndex == 9) // First practice question
                {
                    mainQuestion.sprite = practice_E1[0].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
                else if (insIndex == 11)
                {
                    mainQuestion.sprite = practice_E2[0].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer
                }
                else if (insIndex == 13)
                {
                    mainQuestion.sprite = practice_E3[0].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                } 
            }

            if (formalTestingStart)
            {
                EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialIndex.ToString() + ", 1");
                trialIndex++; // Proceed to the next testing trial
            }       
                
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            if (answerPracticeQ) // When the participant is making a response to one of the practice questions
            {
                if (insIndex == 9) // First practice question
                {
                    mainQuestion.sprite = practice_E1[1].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
                else if (insIndex == 11)
                {
                    mainQuestion.sprite = practice_E2[1].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer
                }
                else if (insIndex == 13)
                {
                    mainQuestion.sprite = practice_E3[1].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
            }

            if (formalTestingStart)
            {
                EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialIndex.ToString() + ", 2");
                trialIndex++; // Proceed to the next testing trial
            }

        }

        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            if (answerPracticeQ) // When the participant is making a response to one of the practice questions
            {
                if (insIndex == 9) // First practice question
                {
                    mainQuestion.sprite = practice_E1[2].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
                else if (insIndex == 11)
                {
                    mainQuestion.sprite = practice_E2[2].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer
                }
                else if (insIndex == 13)
                {
                    mainQuestion.sprite = practice_E3[2].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
            }

            if (formalTestingStart)
            {
                EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialIndex.ToString() + ", 3");
                trialIndex++; // Proceed to the next testing trial
            }

        }

        if (Input.GetKeyDown(KeyCode.Alpha4))
        {
            if (answerPracticeQ) // When the participant is making a response to one of the practice questions
            {
                if (insIndex == 9) // First practice question
                {
                    mainQuestion.sprite = practice_E1[3].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
                else if (insIndex == 11)
                {
                    mainQuestion.sprite = practice_E2[3].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer
                }
                else if (insIndex == 13)
                {
                    mainQuestion.sprite = practice_E3[3].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
            }

            if (formalTestingStart)
            {
                EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialIndex.ToString() + ", 4");
                trialIndex++; // Proceed to the next testing trial
            }

        }

        if (Input.GetKeyDown(KeyCode.Alpha5))
        {
            if (answerPracticeQ) // When the participant is making a response to one of the practice questions
            {
                if (insIndex == 9) // First practice question
                {
                    mainQuestion.sprite = practice_E1[4].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
                else if (insIndex == 11)
                {
                    mainQuestion.sprite = practice_E2[4].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer
                }
                else if (insIndex == 13)
                {
                    mainQuestion.sprite = practice_E3[4].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
            }

            if (formalTestingStart)
            {
                EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialIndex.ToString() + ", 5");
                trialIndex++; // Proceed to the next testing trial
            }

        }

        if (Input.GetKeyDown(KeyCode.Alpha6))
        {
            if (answerPracticeQ) // When the participant is making a response to one of the practice questions
            {
                if (insIndex == 9) // First practice question
                {
                    mainQuestion.sprite = practice_E1[5].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
                else if (insIndex == 11)
                {
                    mainQuestion.sprite = practice_E2[5].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer
                }
                else if (insIndex == 13)
                {
                    mainQuestion.sprite = practice_E3[5].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
            }

            if (formalTestingStart)
            {
                EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialIndex.ToString() + ", 6");
                trialIndex++; // Proceed to the next testing trial
            }

        }

        if (Input.GetKeyDown(KeyCode.Alpha7))
        {
            if (answerPracticeQ) // When the participant is making a response to one of the practice questions
            {
                if (insIndex == 9) // First practice question
                {
                    mainQuestion.sprite = practice_E1[6].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
                else if (insIndex == 11)
                {
                    mainQuestion.sprite = practice_E2[6].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer
                }
                else if (insIndex == 13)
                {
                    mainQuestion.sprite = practice_E3[6].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
            }

            if (formalTestingStart)
            {
                EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialIndex.ToString() + ", 7");
                trialIndex++; // Proceed to the next testing trial
            }

        }

        if (Input.GetKeyDown(KeyCode.Alpha8))
        {
            if (answerPracticeQ) // When the participant is making a response to one of the practice questions
            {
                if (insIndex == 9) // First practice question
                {
                    mainQuestion.sprite = practice_E1[7].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
                else if (insIndex == 11)
                {
                    mainQuestion.sprite = practice_E2[7].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer
                }
                else if (insIndex == 13)
                {
                    mainQuestion.sprite = practice_E3[7].sprite; // Show what the participant just answered
                    lookAtResponse = true; // Participant is now looking at their own answer 
                }
            }

            if (formalTestingStart)
            {
                EventLogger.Instance.LogEvent("Participant made a response," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + trialIndex.ToString() + ", 8");
                trialIndex++; // Proceed to the next testing trial
            }

        }

    }
}
