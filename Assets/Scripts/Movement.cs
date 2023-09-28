
using System.Collections.Generic;
using System.Collections;
using UnityEngine;

public class PlayerRun : MonoBehaviour
{




	public Rigidbody2D RB { get; private set; }
	public bool IsFacingRight { get; private set; }
	private Vector2 _moveInput;
	public float runAccelAmount = 0.1F;
	public float runDeccelAmount = 0.05F;
	public float runMaxSpeed = 5F;
	public bool MvmOk = false;
	public int SceneChange = 1;
	public int LogicChange;
	public GameObject EndBattleButton;

	private void Awake()
	{
		RB = GetComponent<Rigidbody2D>();
	}

	private void Start()
	{
		IsFacingRight = true;
		SceneChange = 1;
	}

	public void EndBattle()
	{
		SceneChange = 1;
		EndBattleButton.SetActive(false);
		

	}
	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.gameObject.layer == 6)
		{
			SceneChange++;
		}

	}

	void Update()
	{
		



		if (SceneChange == 1)
		{
			MvmOk = true;
			_moveInput.x = Input.GetAxisRaw("Horizontal");
			_moveInput.y = Input.GetAxisRaw("Vertical");
			if (_moveInput.x != 0)
				CheckDirectionToFace(_moveInput.x > 0);
		}
		if (SceneChange >= 2)
		{
			EndBattleButton.SetActive(true);
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
	
	#region CHECK METHODS
	public void CheckDirectionToFace(bool isMovingRight)
	{
		if (isMovingRight != IsFacingRight)
			Turn();
	}
	#endregion
}