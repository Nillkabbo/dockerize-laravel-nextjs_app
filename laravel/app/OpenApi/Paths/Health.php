<?php

namespace App\OpenApi\Paths;

use OpenApi\Annotations as OA;

/**
 * @OA\PathItem(path="/api/health",
 *   @OA\Get(
 *     summary="Health check",
 *     operationId="healthCheck",
 *     tags={"System"},
 *     @OA\Response(response=200, description="Service healthy")
 *   )
 * )
 */
class Health
{
}


