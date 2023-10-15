using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spinnn : MonoBehaviour
{

    public Rigidbody2D RB;
    public float AnimCounter = 0.5f;
    public float AnimType = 1f;
    private void Awake()
    {
        
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        AnimCounter += 0.1f * AnimType;
        RB.rotation = AnimCounter;
        if (AnimCounter > 10)
        {
            AnimType = -1;
        }
        if (AnimCounter < -10)
        {
            AnimType = 1;
        }
    }
}
