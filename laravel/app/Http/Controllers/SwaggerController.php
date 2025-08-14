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
        // Get the API docs URL
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
        html { box-sizing: border-box; overflow: -moz-scrollbars-vertical; overflow-y: scroll; }
        *, *:before, *:after { box-sizing: inherit; }
        body { margin:0; background: #fafafa; }
    </style>
</head>
<body>
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
                persistAuthorization: false,
                requestInterceptor: function(request) {
                    request.headers['X-CSRF-TOKEN'] = '';
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
