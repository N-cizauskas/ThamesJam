using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IceKill : MonoBehaviour

     
{

    public float deadZone = -4;
    
    void Update()
    {
        if (transform.position.y < deadZone)
        {
            Destroy(gameObject);
        }
    }
}
