<?php

namespace Tests\Unit;

use App\Http\Controllers\Api\AuthController;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\PersonalAccessToken;
use Tests\TestCase;

class AuthControllerTest extends TestCase
{
    use RefreshDatabase;

    protected $authController;

    protected function setUp(): void
    {
        parent::setUp();
        $this->authController = new AuthController();
    }

    /**
     * Test user registration with valid data
     */
    public function test_register_with_valid_data(): void
    {
        $request = new Request();
        $request->merge([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response = $this->authController->register($request);

        $this->assertEquals(201, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertTrue($data['success']);
        $this->assertEquals('User registered successfully', $data['message']);
        $this->assertEquals('Test User', $data['data']['user']['name']);
        $this->assertEquals('test@example.com', $data['data']['user']['email']);
        $this->assertEquals('Bearer', $data['data']['token_type']);
        $this->assertNotEmpty($data['data']['token']);

        // Verify user was created in database
        $this->assertDatabaseHas('users', [
            'name' => 'Test User',
            'email' => 'test@example.com'
        ]);
    }

    /**
     * Test user registration validation failure
     */
    public function test_register_validation_failure(): void
    {
        $request = new Request();
        $request->merge([
            'name' => 'Test User',
            'email' => 'invalid-email',
            'password' => 'short',
            'password_confirmation' => 'different',
        ]);

        $response = $this->authController->register($request);

        $this->assertEquals(422, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertFalse($data['success']);
        $this->assertEquals('Validation failed', $data['message']);
        $this->assertArrayHasKey('errors', $data);
    }

    /**
     * Test user login with valid credentials
     */
    public function test_login_with_valid_credentials(): void
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => Hash::make('password123'),
        ]);

        $request = new Request();
        $request->merge([
            'email' => 'test@example.com',
            'password' => 'password123',
        ]);

        $response = $this->authController->login($request);

        $this->assertEquals(200, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertTrue($data['success']);
        $this->assertEquals('Login successful', $data['message']);
        $this->assertEquals($user->id, $data['data']['user']['id']);
        $this->assertEquals('Bearer', $data['data']['token_type']);
        $this->assertNotEmpty($data['data']['token']);
    }

    /**
     * Test user login with invalid credentials
     */
    public function test_login_with_invalid_credentials(): void
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => Hash::make('password123'),
        ]);

        $request = new Request();
        $request->merge([
            'email' => 'test@example.com',
            'password' => 'wrongpassword',
        ]);

        $response = $this->authController->login($request);

        $this->assertEquals(401, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertFalse($data['success']);
        $this->assertEquals('Invalid credentials', $data['message']);
    }

    /**
     * Test getting authenticated user profile
     */
    public function test_get_user_profile(): void
    {
        $user = User::factory()->create([
            'name' => 'Test User',
            'email' => 'test@example.com',
        ]);

        $request = new Request();
        $request->setUserResolver(function () use ($user) {
            return $user;
        });

        $response = $this->authController->me($request);

        $this->assertEquals(200, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertTrue($data['success']);
        $this->assertEquals('User information retrieved successfully', $data['message']);
        $this->assertEquals($user->id, $data['data']['user']['id']);
        $this->assertEquals($user->name, $data['data']['user']['name']);
        $this->assertEquals($user->email, $data['data']['user']['email']);
    }

    /**
     * Test user logout
     */
    public function test_user_logout(): void
    {
        $user = User::factory()->create();
        $token = $user->createToken('auth_token');

        $request = new Request();
        $request->setUserResolver(function () use ($user) {
            return $user;
        });

        // Mock the currentAccessToken method
        $mockToken = $this->createMock(PersonalAccessToken::class);
        $mockToken->method('delete')->willReturn(true);
        
        $user = $this->partialMock(User::class, function ($mock) use ($mockToken) {
            $mock->shouldReceive('currentAccessToken')->andReturn($mockToken);
        });

        $request->setUserResolver(function () use ($user) {
            return $user;
        });

        $response = $this->authController->logout($request);

        $this->assertEquals(200, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertTrue($data['success']);
        $this->assertEquals('Successfully logged out', $data['message']);
    }

    /**
     * Test token refresh
     */
    public function test_token_refresh(): void
    {
        $user = User::factory()->create();
        $oldToken = $user->createToken('auth_token');

        $request = new Request();
        $request->setUserResolver(function () use ($user) {
            return $user;
        });

        // Mock the currentAccessToken method
        $mockToken = $this->createMock(PersonalAccessToken::class);
        $mockToken->method('delete')->willReturn(true);
        
        $user = $this->partialMock(User::class, function ($mock) use ($mockToken) {
            $mock->shouldReceive('currentAccessToken')->andReturn($mockToken);
            $mock->shouldReceive('createToken')->andReturn((object) [
                'plainTextToken' => 'new_token_123'
            ]);
        });

        $request->setUserResolver(function () use ($user) {
            return $user;
        });

        $response = $this->authController->refresh($request);

        $this->assertEquals(200, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertTrue($data['success']);
        $this->assertEquals('Token refreshed successfully', $data['message']);
        $this->assertEquals('Bearer', $data['data']['token_type']);
        $this->assertNotEmpty($data['data']['token']);
    }

    /**
     * Test password hashing in registration
     */
    public function test_password_is_hashed_in_registration(): void
    {
        $request = new Request();
        $request->merge([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $this->authController->register($request);

        $user = User::where('email', 'test@example.com')->first();
        
        $this->assertNotNull($user);
        $this->assertTrue(Hash::check('password123', $user->password));
        $this->assertNotEquals('password123', $user->password);
    }

    /**
     * Test email uniqueness validation
     */
    public function test_email_uniqueness_validation(): void
    {
        // Create first user
        User::factory()->create(['email' => 'test@example.com']);

        $request = new Request();
        $request->merge([
            'name' => 'Another User',
            'email' => 'test@example.com', // Same email
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response = $this->authController->register($request);

        $this->assertEquals(422, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertFalse($data['success']);
        $this->assertArrayHasKey('errors', $data);
        $this->assertArrayHasKey('email', $data['errors']);
    }

    /**
     * Test password confirmation validation
     */
    public function test_password_confirmation_validation(): void
    {
        $request = new Request();
        $request->merge([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'password_confirmation' => 'differentpassword',
        ]);

        $response = $this->authController->register($request);

        $this->assertEquals(422, $response->getStatusCode());
        
        $data = json_decode($response->getContent(), true);
        
        $this->assertFalse($data['success']);
        $this->assertArrayHasKey('errors', $data);
        $this->assertArrayHasKey('password', $data['errors']);
    }
}
