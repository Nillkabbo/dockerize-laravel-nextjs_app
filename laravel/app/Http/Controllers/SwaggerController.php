<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;

class SwaggerController extends Controller
{
    /**
     * Display the Swagger UI interface
     */
    public function api(Request $request): Response
    {
        // Get the API docs URL - use the regenerated Laravel OpenAPI spec
        $docsUrl = url('/docs');
        
        $html = <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laravel + Next.js Full Stack API Documentation</title>
    <link rel="stylesheet" type="text/css" href="https://unpkg.com/swagger-ui-dist@5.27.1/swagger-ui.css" />
    <style>
        body { 
            margin: 0; 
            background: #fafafa; 
        }
        .instructions {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 5px;
            margin: 20px;
            font-family: Arial, sans-serif;
        }
    </style>
</head>
<body>
    <div class="instructions">
        <h3>🔐 How to Use Authentication:</h3>
        <ol>
            <li><strong>Login first:</strong> Use <code>/api/auth/login</code> with <code>test@example.com / password</code></li>
            <li><strong>Copy the token:</strong> From the login response (data.token field)</li>
            <li><strong>Click "Authorize" button</strong> above and enter: <code>Bearer YOUR_TOKEN_HERE</code></li>
            <li><strong>Test protected endpoints:</strong> All authenticated routes will now work automatically!</li>
        </ol>
        <p><strong>Note:</strong> Replace <code>YOUR_TOKEN_HERE</code> with the actual token from login response.</p>
        <p><strong>Important:</strong> Use the format: <code>Bearer YOUR_TOKEN_HERE</code> (include the word "Bearer")</p>
    </div>
    
    <div id="swagger-ui"></div>
    
    <script src="https://unpkg.com/swagger-ui-dist@5.27.1/swagger-ui-bundle.js"></script>
    <script src="https://unpkg.com/swagger-ui-dist@5.27.1/swagger-ui-standalone-preset.js"></script>
    <script>
        window.onload = function() {
            const ui = SwaggerUIBundle({
                url: '{$docsUrl}',
                dom_id: '#swagger-ui',
                deepLinking: true,
                presets: [
                    SwaggerUIBundle.presets.apis,
                    SwaggerUIStandalonePreset
                ],
                plugins: [
                    SwaggerUIBundle.plugins.DownloadUrl
                ],
                layout: "StandaloneLayout",
                docExpansion: "none",
                filter: true,
                persistAuthorization: true,
                requestInterceptor: function(request) {
                    // Ensure proper Bearer token format
                    if (request.headers.Authorization && !request.headers.Authorization.startsWith('Bearer ')) {
                        request.headers.Authorization = 'Bearer ' + request.headers.Authorization;
                    }
                    return request;
                }
            });
            window.ui = ui;
        }
    </script>
</body>
</html>
HTML;

        return response($html)->header('Content-Type', 'text/html');
    }
}

