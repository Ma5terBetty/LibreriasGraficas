using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour
{
    Rigidbody _rigidBody;
    [SerializeField] float _speed;


    float _horizontalInput;
    float _verticalInput;

    Vector3 _moveDir;

    private void Awake()
    {
        _rigidBody = GetComponent<Rigidbody>();
        _rigidBody.freezeRotation = true;
    }
    void MovementInputs()
    {
        _horizontalInput = Input.GetAxisRaw("Horizontal");
        _verticalInput = Input.GetAxisRaw("Vertical");
    }
    private void Update()
    {
        MovementInputs();
        ClampVelocity();
    }
    void MovePlayer()
    {
        Transform cam = Camera.main.transform;

        _moveDir = cam.forward * _verticalInput + cam.right * _horizontalInput;

        _moveDir = new Vector3(_moveDir.x, 0, _moveDir.z);

        _rigidBody.AddForce(_moveDir * _speed * 10f, ForceMode.Force);
    }
    private void FixedUpdate()
    {
        MovePlayer();
    }

    void ClampVelocity()
    {
        Vector3 flatVel = new Vector3(_rigidBody.velocity.x, 0, _rigidBody.velocity.z);

        if (flatVel.magnitude > _speed)
        { 
            Vector3 limitedVel = flatVel.normalized * _speed;
            _rigidBody.velocity = new Vector3(limitedVel.x, _rigidBody.velocity.y, limitedVel.z);
        }
    }
}
