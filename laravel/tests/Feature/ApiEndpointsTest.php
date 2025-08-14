<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class ApiEndpointsTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;
    protected $token;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create a test user and token for authenticated tests
        $this->user = User::factory()->create();
        $this->token = $this->user->createToken('auth_token')->plainTextToken;
    }

    /**
     * Test health check endpoint
     */
    public function test_health_check_endpoint(): void
    {
        $response = $this->getJson('/api/health');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'status',
                'timestamp',
                'service',
                'version'
            ])
            ->assertJson([
                'status' => 'healthy',
                'service' => 'Laravel API',
                'version' => '1.0.0'
            ]);
    }

    /**
     * Test getting all users (authenticated)
     */
    public function test_get_all_users_authenticated(): void
    {
        // Create some additional users
        User::factory()->count(3)->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/users');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data',
                'message'
            ])
            ->assertJson([
                'success' => true,
                'message' => 'Users retrieved successfully'
            ]);

        // Should have at least 4 users (1 from setUp + 3 created)
        $this->assertGreaterThanOrEqual(4, count($response->json('data')));
    }

    /**
     * Test getting all users without authentication
     */
    public function test_get_all_users_unauthenticated(): void
    {
        $response = $this->getJson('/api/users');

        $response->assertStatus(401)
            ->assertJson([
                'success' => false,
                'message' => 'Unauthenticated',
                'code' => 'UNAUTHENTICATED'
            ]);
    }

    /**
     * Test creating a new user (authenticated)
     */
    public function test_create_user_authenticated(): void
    {
        $userData = [
            'name' => 'New Test User',
            'email' => 'newuser@example.com',
            'password' => 'password123'
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/users', $userData);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'success',
                'message',
                'data' => [
                    'id',
                    'name',
                    'email',
                    'created_at'
                ]
            ])
            ->assertJson([
                'success' => true,
                'message' => 'User created successfully',
                'data' => [
                    'name' => 'New Test User',
                    'email' => 'newuser@example.com'
                ]
            ]);

        // Verify user was created in database
        $this->assertDatabaseHas('users', [
            'name' => 'New Test User',
            'email' => 'newuser@example.com'
        ]);
    }

    /**
     * Test creating user without authentication
     */
    public function test_create_user_unauthenticated(): void
    {
        $userData = [
            'name' => 'New Test User',
            'email' => 'newuser@example.com',
            'password' => 'password123'
        ];

        $response = $this->postJson('/api/users', $userData);

        $response->assertStatus(401);
    }

    /**
     * Test creating user with validation errors
     */
    public function test_create_user_validation_errors(): void
    {
        // Test missing required fields
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/users', []);

        $response->assertStatus(422)
            ->assertJsonStructure([
                'success',
                'message',
                'errors'
            ]);

        // Test duplicate email
        $existingUser = User::factory()->create(['email' => 'existing@example.com']);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/users', [
            'name' => 'Test User',
            'email' => 'existing@example.com',
            'password' => 'password123'
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
    }

    /**
     * Test getting a specific user by ID (authenticated)
     */
    public function test_get_user_by_id_authenticated(): void
    {
        $testUser = User::factory()->create([
            'name' => 'Specific User',
            'email' => 'specific@example.com'
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson("/api/users/{$testUser->id}");

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data' => [
                    'id',
                    'name',
                    'email',
                    'created_at'
                ]
            ])
            ->assertJson([
                'success' => true,
                'message' => 'User retrieved successfully',
                'data' => [
                    'id' => $testUser->id,
                    'name' => 'Specific User',
                    'email' => 'specific@example.com'
                ]
            ]);
    }

    /**
     * Test getting non-existent user
     */
    public function test_get_nonexistent_user(): void
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/users/99999');

        $response->assertStatus(404)
            ->assertJson([
                'success' => false,
                'message' => 'User not found'
            ]);
    }

    /**
     * Test updating a user (authenticated)
     */
    public function test_update_user_authenticated(): void
    {
        $testUser = User::factory()->create([
            'name' => 'Original Name',
            'email' => 'original@example.com'
        ]);

        $updateData = [
            'name' => 'Updated Name',
            'email' => 'updated@example.com'
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->putJson("/api/users/{$testUser->id}", $updateData);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'message',
                'data' => [
                    'id',
                    'name',
                    'email',
                    'updated_at'
                ]
            ])
            ->assertJson([
                'success' => true,
                'message' => 'User updated successfully',
                'data' => [
                    'id' => $testUser->id,
                    'name' => 'Updated Name',
                    'email' => 'updated@example.com'
                ]
            ]);

        // Verify user was updated in database
        $this->assertDatabaseHas('users', [
            'id' => $testUser->id,
            'name' => 'Updated Name',
            'email' => 'updated@example.com'
        ]);
    }

    /**
     * Test updating user without authentication
     */
    public function test_update_user_unauthenticated(): void
    {
        $testUser = User::factory()->create();

        $response = $this->putJson("/api/users/{$testUser->id}", [
            'name' => 'Updated Name'
        ]);

        $response->assertStatus(401);
    }

    /**
     * Test updating non-existent user
     */
    public function test_update_nonexistent_user(): void
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->putJson('/api/users/99999', [
            'name' => 'Updated Name'
        ]);

        $response->assertStatus(404)
            ->assertJson([
                'success' => false,
                'message' => 'User not found'
            ]);
    }

    /**
     * Test deleting a user (authenticated)
     */
    public function test_delete_user_authenticated(): void
    {
        $testUser = User::factory()->create([
            'name' => 'User To Delete',
            'email' => 'delete@example.com'
        ]);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->deleteJson("/api/users/{$testUser->id}");

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'User deleted successfully'
            ]);

        // Verify user was deleted from database
        $this->assertDatabaseMissing('users', [
            'id' => $testUser->id
        ]);
    }

    /**
     * Test deleting user without authentication
     */
    public function test_delete_user_unauthenticated(): void
    {
        $testUser = User::factory()->create();

        $response = $this->deleteJson("/api/users/{$testUser->id}");

        $response->assertStatus(401);
    }

    /**
     * Test deleting non-existent user
     */
    public function test_delete_nonexistent_user(): void
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->deleteJson('/api/users/99999');

        $response->assertStatus(404)
            ->assertJson([
                'success' => false,
                'message' => 'User not found'
            ]);
    }

    /**
     * Test user search functionality (authenticated)
     */
    public function test_user_search_authenticated(): void
    {
        // Create users with specific names for search
        User::factory()->create(['name' => 'John Doe']);
        User::factory()->create(['name' => 'Jane Doe']);
        User::factory()->create(['name' => 'Bob Smith']);

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/users/search/doe');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data',
                'message'
            ]);

        // Should find users with "doe" in their name
        $data = $response->json('data');
        $this->assertGreaterThan(0, count($data));
    }

    /**
     * Test user statistics (authenticated)
     */
    public function test_user_statistics_authenticated(): void
    {
        // Create some users
        User::factory()->count(5)->create();

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->getJson('/api/users/stats');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data',
                'message'
            ]);

        // Should have statistics data
        $data = $response->json('data');
        $this->assertNotEmpty($data);
    }

    /**
     * Test deprecated user endpoint
     */
    public function test_deprecated_user_endpoint(): void
    {
        $response = $this->getJson('/api/user');

        $response->assertStatus(410)
            ->assertJson([
                'success' => false,
                'message' => 'This endpoint is deprecated. Use /auth/me with Bearer token instead.',
                'code' => 'DEPRECATED_ENDPOINT'
            ]);
    }
}
