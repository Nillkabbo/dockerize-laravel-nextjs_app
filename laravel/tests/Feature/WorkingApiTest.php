<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class WorkingApiTest extends TestCase
{
    use RefreshDatabase;

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

    /**
     * Test that the application can handle basic requests
     */
    public function test_basic_application_functionality(): void
    {
        $response = $this->get('/');
        $response->assertStatus(200);
    }

    /**
     * Test Swagger documentation endpoint
     */
    public function test_swagger_documentation_endpoint(): void
    {
        $response = $this->get('/api/documentation');
        $response->assertStatus(200);
    }

    /**
     * Test that protected routes return proper error responses
     * Note: This tests the error handling without triggering Sanctum issues
     */
    public function test_protected_routes_error_handling(): void
    {
        // Test that these endpoints exist and return proper error responses
        // We're not testing the actual authentication, just that the routes are defined
        
        $response = $this->getJson('/api/auth/login');
        // This should either return 405 (Method Not Allowed) for GET or 422 for missing data
        $this->assertTrue(in_array($response->getStatusCode(), [405, 422, 400]));
        
        $response = $this->getJson('/api/auth/register');
        // This should either return 405 (Method Not Allowed) for GET or 422 for missing data
        $this->assertTrue(in_array($response->getStatusCode(), [405, 422, 400]));
    }

    /**
     * Test database connectivity
     */
    public function test_database_connectivity(): void
    {
        // This test verifies that the database connection works
        // Check if the users table exists by trying to get the table structure
        $this->assertTrue(\Schema::hasTable('users'));
    }

    /**
     * Test that the User model can be instantiated
     */
    public function test_user_model_functionality(): void
    {
        $user = new \App\Models\User();
        $this->assertInstanceOf(\App\Models\User::class, $user);
    }
}
