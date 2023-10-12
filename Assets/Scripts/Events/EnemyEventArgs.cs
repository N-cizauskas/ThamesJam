using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyEventArgs : EventArgs
{
    public String EnemyName {get; private set;} // placeholder; should instead be some enemy object that holds more information like subtext and battle stats

    public EnemyEventArgs(String enemy)
    {
        this.EnemyName = enemy;
    }
    
}
