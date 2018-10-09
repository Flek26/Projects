using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerScript : MonoBehaviour {

    public int speed; //speed in units per second that player moves


	// Use this for initialization
	void Start () {
        speed = 40;
	}
	
	// Update is called once per frame
	void Update () {
        //Get input from the keyboard - Horizontal 
        //input.getaxis return value between -1 and 1
        //pushing left gives -1, right 1, no keys == 0;
        Debug.Log(Input.GetAxis("Horizontal"));
        //Move the player
        //vector 3 is x,y,z movement
        //deltatime is time between frames
        //right = 1,0,0
        transform.Translate(Vector3.right * Input.GetAxis("Horizontal") * Time.deltaTime * speed);

        //check i fplayer is beyond edge
        //if he is, put back on screen
        if(transform.position.x < -19.43f){
            transform.position = new Vector3(-19.43f, transform.position.y, 0);
        }
        if (transform.position.x > 19.43f)
        {
            transform.position = new Vector3(19.43f, transform.position.y, 0);
        }
    }

}
