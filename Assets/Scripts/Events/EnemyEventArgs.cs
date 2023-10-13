using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyEventArgs : EventArgs
{
    public EnemyData EnemyData {get; private set;}

    public EnemyEventArgs(EnemyData enemyData)
    {
        this.EnemyData = enemyData;
    }
}
