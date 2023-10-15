using System;
using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerRun : MonoBehaviour
{
    private static event EventHandler<EnemyEventArgs> RaiseEncounterEvent;     // Event raised upon colliding with an enemy

	public static void RegisterEncounterHandler(EventHandler<EnemyEventArgs> handler)
    {
        RaiseEncounterEvent += handler;
    }



	public Rigidbody2D RB { get; private set; }
	public bool IsFacingRight { get; private set; }
	private Vector2 _moveInput;
	public float runAccelAmount = 0.1F;
	public float runDeccelAmount = 0.05F;
	public float runMaxSpeed = 5F;
	public float CurrentStrength = 1f;
	public bool MvmOk = false;
	public int SceneChange = 1;
	public int LogicChange;
	public GameObject FlightOrFlirt; //2 (Scene Change number) Normal game play is 1
	public GameObject FightScreen; //3
	public GameObject FlirtScreen; //4
	public GameObject BossScreen; //5
	public string Level_2;
	public string Level_3;
	public string Level_4;
	public string Level_5;
	public float SlowTimer = 0f;
	public bool Slowed = false;
	public static int tessieCharm = 0; // Used for flirt? Possible?
	public static string collidedMob;

	private void Awake()
	{
		RB = GetComponent<Rigidbody2D>();
	}

	private void Start()
	{
		IsFacingRight = true;
		SceneChange = 1;
		FlightOrFlirt.SetActive(false);
		FightScreen.SetActive(false);
		FlirtScreen.SetActive(false);
	}

	public void EndBattle() //Send all battle ending functions here
	{
		SceneChange = 1;
		FlightOrFlirt.SetActive(false);
		FightScreen.SetActive(false);
		FlirtScreen.SetActive(false);
	}

	public void FightBattle()
	{
		SceneChange = 3;
		FlightOrFlirt.SetActive(false);
		FightScreen.SetActive(true);
	}

	public void FlirtBattle()
	{
		SceneChange = 4;
		FlightOrFlirt.SetActive(false);
		FlirtScreen.SetActive(true);
	}
	public void BossBattle()
	{
		SceneChange = 1; //Replace These 2 lines with 5 when completed
		FlightOrFlirt.SetActive(false);
	}

	private void OnTriggerEnter2D(Collider2D collision) //This solves collision with non enemy objects
	{
		if (collision.gameObject.layer == 6) //All non boss are to be layer 6
		{
			// Determine the mob that you collided with
			// This is useful for loading the correct objects and scripts
			collidedMob = collision.gameObject.name;

			if (GameStateManager.Instance.GameState == GameState.OVERWORLD)
			{
				EnemyData enemyData = collision.gameObject.GetComponent<Enemy>().EnemyData;
				RaiseEncounterEvent?.Invoke(this, new EnemyEventArgs(enemyData));
			}
			// SceneChange = 2;			
		}

		if (collision.gameObject.layer == 7) //All boss to be layer 7
		{
			SceneChange = 5;
		}
		if (collision.gameObject.layer == 8 == true) //Slow terrain
		{

			runMaxSpeed = 0.5F;

		}
		
	}
	private void OnTriggerExit2D(Collider2D collision)
    {
			runMaxSpeed = 5F;
	}

    private void OnCollisionStay2D(Collision2D collision)
    {
		if (collision.gameObject.layer == 9 == true) //Slow terrain
		{

			RB.velocity = Vector2.left * CurrentStrength;

		}
	}



    void Update()
	{
     
		

		if (SceneChange == 0) //Menu
		{
			
			MvmOk = false;
			RB.velocity = new Vector2(0, 0);
		}


		if (SceneChange == 1) //Normal movement
		{
			MvmOk = true;
			_moveInput.x = Input.GetAxisRaw("Horizontal");
			_moveInput.y = Input.GetAxisRaw("Vertical");
			if (_moveInput.x != 0)
				CheckDirectionToFace(_moveInput.x > 0);
		}
		if (SceneChange == 2) //Enemy
		{
			FlightOrFlirt.SetActive(true);
			MvmOk = false;
			RB.velocity = new Vector2(0, 0);
		}

		
		
		if (SceneChange == 5) //Boss
		{
			BossScreen.SetActive(true);
			MvmOk = false;
			RB.velocity = new Vector2(0, 0);
		}

	}
	
	
	

	private void FixedUpdate()
	{
		Run();

		//IdleCheck();
	}

	
	private void Run()
	{
		if (GameStateManager.inEncounter == true)
        {
			// Halt current movement
			RB.velocity = new Vector2(0, 0);
			return;
        }
		if(	MvmOk == true )
		{ 
			float targetSpeedx = _moveInput.x * runMaxSpeed;
			float targetSpeedy = _moveInput.y * runMaxSpeed;
			float accelRatex;
			float accelRatey;


			accelRatex = (Mathf.Abs(targetSpeedx) > 0.01f) ? runAccelAmount : runDeccelAmount;
			accelRatey = (Mathf.Abs(targetSpeedy) > 0.01f) ? runAccelAmount : runDeccelAmount;





			float speedDifx = targetSpeedx - RB.velocity.x;
			float movementx = speedDifx * accelRatex;

			float speedDify = targetSpeedy - RB.velocity.y;
			float movementy = speedDify * accelRatey;

			Vector2 acceleration = new Vector2(movementx, movementy);


			RB.velocity = new Vector2(RB.velocity.x + (Time.deltaTime * movementx), RB.velocity.y + (Time.deltaTime * movementy));
		}
	}

	private void Turn()
	{
		//stores scale and flips the player along the x axis, 
		Vector3 scale = transform.localScale;
		scale.x *= -1;
		transform.localScale = scale;

		IsFacingRight = !IsFacingRight;
	}


	public void CheckDirectionToFace(bool isMovingRight)
	{
		if (isMovingRight != IsFacingRight && GameStateManager.canTurn == true)
			{
				Turn();
            }
	}

	public void NextLevel_2()
    {
		
		SceneManager.LoadScene(Level_2);

    }
	public void NextLevel_3()
	{

		SceneManager.LoadScene(Level_3);

	}
	public void NextLevel_4()
	{

		SceneManager.LoadScene(Level_4);

	}

	public void NextLevel_5()
	{

		SceneManager.LoadScene(Level_5);

	}

	/**
     * DEBUG FUNCTIONS
     * The idea is that these should get called as a result of some easily controllable action, e.g. button press
    **/
    public void DebugStartEncounter(EnemyData enemy)
    {
        RaiseEncounterEvent?.Invoke(this, new EnemyEventArgs(enemy));
    }

}