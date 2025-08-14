<?php

namespace App\OpenApi\Paths;

use OpenApi\Annotations as OA;

/**
 * @OA\Tag(
 *   name="Users",
 *   description="Operations about users"
 * )
 *
 * @OA\PathItem(path="/api/users",
 *   @OA\Get(
 *     summary="List users",
 *     operationId="listUsers",
 *     tags={"Users"},
 *     @OA\Response(response=200, description="Users retrieved successfully")
 *   ),
 *   @OA\Post(
 *     summary="Create user",
 *     operationId="createUser",
 *     tags={"Users"},
 *     @OA\RequestBody(
 *       required=true,
 *       @OA\JsonContent(
 *         required={"name","email","password"},
 *         @OA\Property(property="name", type="string"),
 *         @OA\Property(property="email", type="string"),
 *         @OA\Property(property="password", type="string")
 *       )
 *     ),
 *     @OA\Response(response=201, description="User created successfully")
 *   )
 * )
 *
 * @OA\PathItem(path="/api/users/{id}",
 *   @OA\Parameter(name="id", in="path", required=true, @OA\Schema(type="integer")),
 *   @OA\Get(
 *     summary="Show user",
 *     operationId="getUser",
 *     tags={"Users"},
 *     @OA\Response(response=200, description="User retrieved successfully")
 *   ),
 *   @OA\Put(
 *     summary="Update user",
 *     operationId="updateUser",
 *     tags={"Users"},
 *     @OA\RequestBody(
 *       required=false,
 *       @OA\JsonContent(
 *         @OA\Property(property="name", type="string"),
 *         @OA\Property(property="email", type="string")
 *       )
 *     ),
 *     @OA\Response(response=200, description="User updated successfully")
 *   ),
 *   @OA\Delete(
 *     summary="Delete user",
 *     operationId="deleteUser",
 *     tags={"Users"},
 *     @OA\Response(response=200, description="User deleted successfully")
 *   )
 * )
 */
class Users
{
}


