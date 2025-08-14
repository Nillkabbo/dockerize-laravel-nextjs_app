<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BasicApiTest extends TestCase
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
}
