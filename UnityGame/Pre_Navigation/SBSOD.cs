using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using MySceneRecorder;
using MyUtility;

public class SBSOD : MonoBehaviour
{
    [SerializeField]
    // Public UI elements for display of trials / questions / instructions
    public Text trials_text;
    public Text trials_title_text;
    public Text question_text;
    public Text start_text;
    public Text finish_text;
    public InputField input_field;

    // Public game elements
    public int total_trials_num = 15; // 15 questions
    // public string next_scene_name = ;

    // Arrays for the question elements in each trial
    public string[] question_list =
    {
        "I am very good at giving directions.",
        "I have a poor memory for where I left things.",
        "I am very good at judging distances.",
        "My 'sense of direction' is very good.",
        "I tend to think of my environment in terms of cardinal directions (N, S, E, W).",
        "I very easily get lost in a new city.",
        "I enjoy reading maps.",
        "I have trouble understanding directions.",
        "I am very good at reading maps.",
        "I don't remember routes very well while riding as a passenger in a car.",
        "I don't enjoy giving directions.",
        "It's not important to me to know where I am.",
        "I usually let someone else do the navigational planning for long trips.",
        "I can usually remember a new route after I have traveled it only once.",
        "I don't have a very good 'mental map' of my environment."
    };

    int[] question_list_final;

    // Counters
    public int current_trial_num = 1;
    int question_counter = 0;

    bool input_entry_started;           // Whether the player started typing input

    private string next_scene_name = "DVIM_Toy_City_Instructions";       // The next scene (task) to move to when the current one is finished

    //// Epstein Lab Client - Alex's SceneRecorder
    //[SerializeField]
    //private EpsteinLabClient client;

    void Start()
    {
        // Writing in log that the task was started
        Cursor.visible = true;
        ////////
        EventLogger.Instance.LogEvent("Event, Date, Time (H+M), Time (S+MS), Question Number, Question, Answer");     // Header
        EventLogger.Instance.LogEvent("SBSOD survey started," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
        ////////

        // Enabling the starting text, disabling the rest of the UI
        start_text.enabled = true;
        finish_text.enabled = false;
        question_text.enabled = false;
        trials_text.enabled = false;
        trials_title_text.enabled = false;
        input_field.transform.localScale = new Vector3(0, 0, 0);

        // Initializing arrays to the size of the number of trials
        // question_list = new string[total_trials_num];
        question_list_final = new int[total_trials_num];

        input_entry_started = false;

        // Determining the order of question
        Set_questions();
    }

    // Update is called once per frame
    void Update()
    {
        // Presenting the number of trials (current trial number + total trials number)
        trials_text.text = "Question: " + current_trial_num.ToString() + " / " + total_trials_num.ToString();


        // Getting player input - enter press
        if (Input.GetKeyDown(KeyCode.Return))
        {
            if (input_field.text.Length > 0)        // if the player entered a number, record it and move on to the next question
            {
                // Record input of the participant
                EventLogger.Instance.LogEvent("Participant confirmed answer," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + current_trial_num.ToString() + ", -," + input_field.text); 
                
                if (current_trial_num < total_trials_num)           // If this is not the last trial
                {
                    current_trial_num++;
                    Change_question();
                    input_entry_started = false;
                }

                else                // If reached last trial, display the end message
                {
                    question_text.enabled = false;
                    trials_text.enabled = false;
                    trials_title_text.enabled = false;
                    input_field.transform.localScale = new Vector3(0, 0, 0);
                    finish_text.enabled = true;

                    EventLogger.Instance.LogEvent("Finish message displayed," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
                }

            }

            // If there is no input in the input field, ignore the enter press and make sure the input field remains active
            else
            {
                input_field.ActivateInputField();
            }
        }

        else if (Input.anyKeyDown & input_entry_started == false)
        {
            input_entry_started = true;
        }

        // If the player pressed L
        if (Input.GetKeyDown(KeyCode.S))
        {
            if (start_text.enabled == true)     // If this is the start of the game, disable the starting message and activate the UI, and display first question
            {
                ////////
                //EventLogger.Instance.LogEvent("L key pressed," + System.DateTime.Now.ToString("yyyyMMdd,HHmm,ss.ffff") + ",-,-,-,-,-,-,-");
                ////////

                start_text.enabled = false;
                question_text.enabled = true;
                trials_text.enabled = true;
                trials_title_text.enabled = true;
                input_field.transform.localScale = new Vector3(1, 1, 1);

                Change_question();      // Display the first question
            }
        }
        
        if (Input.GetKeyDown(KeyCode.N))
        {
            if (finish_text.enabled == true) // If the end message is displayed and the player pressed 'L', move on to the next task
            {
                EventLogger.Instance.LogEvent("SBSOD session ended," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
                SceneManager.LoadScene(next_scene_name);
                Finish_SBSOD(); // Transition to the next task
            }
        }

        // If escape was pressed, go back to the main menu
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene("DVIM_Main_Menu");
            EventLogger.Instance.LogEvent("Escape key pressed. Entering the main menu," + System.DateTime.Now.ToString("yyyyMMdd, HH:mm, ss.ffff,") + "-, -, -");
        }
    }

    void Set_questions()
    {
        int[] question_list_final_0 = new int[]
             {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};

        for (int i = 0; i < total_trials_num; i++)
        {
            question_list_final[i] = question_list_final_0[i];
        }
    }


    void Change_question()
    {
        // Removing data from the input field
        input_field.text = "";

        // Activating the input field (so that no mouse click on it will be necessary)
        input_field.ActivateInputField();

        // Choosing the question to ask according to the list of questions
        int question_to_ask = question_list_final[question_counter];
        question_counter++;

        // Displaying the new question within the UI
        question_text.text = question_list[question_to_ask];

        ////////
        // Logging
        // EventLogger.Instance.LogEvent("Question changed," + System.DateTime.Now.ToString("yyyyMMdd,HHmm,ss.ffff") + "," + question_to_ask.ToString() + "," + question_list[question_to_ask] + ",-,-,-,-,-");
        ////////
    }

    void Finish_SBSOD()
    {
        // Post event logger data to server

        ////////
        //var client = SceneRecorder.Instance.GetComponent<EpsteinLabClient>();
        //client.PostEventLoggerData(null);
        ////////
    }
}
