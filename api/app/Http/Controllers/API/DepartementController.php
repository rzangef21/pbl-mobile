<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseWrapper;
use App\Http\Controllers\Controller;
use App\Models\Department;
use Illuminate\Http\Request;

class DepartementController extends Controller
{
    public function show_departements()
    {
        $departements = Department::all([
            "id",
            "name",
            "latitude",
            "longitude",
            "radius_meters",
        ]);
        return ResponseWrapper::make(
            "Departements found",
            200,
            true,
            $departements,
            null,
        );
    }
}
