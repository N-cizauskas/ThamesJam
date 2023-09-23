
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



	private void Awake()
	{
		RB = GetComponent<Rigidbody2D>();
	}

	private void Start()
	{
		IsFacingRight = true;
	}

	private void Update()
	{


		_moveInput.x = Input.GetAxisRaw("Horizontal");
		_moveInput.y = Input.GetAxisRaw("Vertical");
		if (_moveInput.x != 0)
		{ CheckDirectionToFace(_moveInput.x > 0); }

		
	}
	
	
	

	private void FixedUpdate()
	{
		Run();

		//IdleCheck();
	}

	
	private void Run()
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

		//Convert this to a vector and apply to rigidbody
		//RB.AddForce(acceleration, ForceMode2D.Force);
		RB.velocity = new Vector2(RB.velocity.x + (Time.deltaTime * movementx), RB.velocity.y + (Time.deltaTime * movementy));
		//RB.AddForce(movementy * Vector2.up, ForceMode2D.Force);
		/*
		 * For those interested here is what AddForce() will do
		 * RB.velocity = new Vector2(RB.velocity.x + (Time.fixedDeltaTime  * speedDif * accelRate) / RB.mass, RB.velocity.y);
		 * Time.fixedDeltaTime is by default in Unity 0.02 seconds equal to 50 FixedUpdate() calls per second
		*/
	}

	private void Turn()
	{
		//stores scale and flips the player along the x axis, 
		Vector3 scale = transform.localScale;
		scale.x *= -1;
		transform.localScale = scale;

		IsFacingRight = !IsFacingRight;
	}
	//private void IdleCheck()
	//{
		//if (RB.velocity.x < 0.1 && RB.velocity.y < 0.1)
		//{
			//yield return new WaitForSecondsRealtime(2);
			//if (RB.velocity.x < 0.1 && RB.velocity.y < 0.1)
			//{
			//	Idle();
			//}
			//}


	//}
	//private void Idle()
	//{ 
	
	
	
	
	//}
	

	#region CHECK METHODS
	public void CheckDirectionToFace(bool isMovingRight)
	{
		if (isMovingRight != IsFacingRight)
			Turn();
	}
	#endregion
}