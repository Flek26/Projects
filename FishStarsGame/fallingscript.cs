using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallingScript : MonoBehaviour {

    public int speed;
    public int score;

	// Use this for initialization
	void Start () {
        speed = 5;
        score = 0;
	}
	
	// Update is called once per frame
	void Update () {
        transform.Translate(Vector3.down * Time.deltaTime * speed);

        if(transform.position.y < -17)
        {
            MoveToTop();
        }
	}

    void MoveToTop()
    {
        float randomNumber = Random.Range(-19.43f, 19.43f);
        float random2 = Random.Range(17, 87);
        Vector3 newpos = new Vector3(randomNumber, random2, 0);
        transform.position = newpos;
    }

    void OnTriggerEnter2D(Collider2D other)
    {

        if( other.CompareTag("sushi"))
        {
            score += 1;
        }

        MoveToTop();
    }
}
