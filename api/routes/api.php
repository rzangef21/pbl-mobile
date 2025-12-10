<?php

use App\Http\Controllers\API\IzinDashboardController;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\AttendanceController;
use App\Http\Controllers\API\ScheduleController;
use App\Http\Controllers\Api\EmployeeController;
use App\Http\Controllers\Api\EmployeeProfileController;
use App\Http\Controllers\Api\EmployeeManagementController;
use App\Http\Controllers\Api\PositionController;
use App\Http\Controllers\Api\DepartmentController;
use App\Http\Controllers\API\PasswordChangeController;
use App\Http\Controllers\API\LetterController;
use App\Http\Controllers\API\TemplateController;
use Illuminate\Support\Facades\Route;

// ========================================
// TEST ROUTE (PUBLIC)
// ========================================
Route::get('/test', function () {
    return response()->json(['status' => 'ok']);
});

// ========================================
// AUTHENTICATION ROUTES (PUBLIC)
// ========================================
Route::post("/login", [AuthController::class, "login"]);
Route::post("/send-token", [PasswordChangeController::class, "send_token"]);
Route::post("/check-token", [PasswordChangeController::class, "check_token"]);
Route::post("/change-password", [PasswordChangeController::class, "change_password"]);

// ========================================
// PROTECTED ROUTES (AUTH REQUIRED)
// ========================================
Route::middleware('auth:sanctum')->group(function () {
    
    // ========== USER ROUTES ==========
    Route::get("/user/{id}", [UserController::class, "show_user"]);
    Route::get("/users", [UserController::class, "show_users"]);
    Route::patch("/user/{id}", [UserController::class, "update_user"]);
    Route::post("/register", [AuthController::class, "register"]);
    Route::post("/logout", [AuthController::class, "logout"]);

    // ========== ATTENDANCE ROUTES ==========
    Route::prefix('absen')->group(function () {
        Route::get('/status', [AttendanceController::class, 'statusHariIni']);
        Route::post('/in', [AttendanceController::class, 'clockIn']);
        Route::post('/out', [AttendanceController::class, 'clockOut']);
    });
    Route::post('/lembur/in', [AttendanceController::class, 'lemburIn']);
    Route::post('/lembur/out', [AttendanceController::class, 'lemburOut']);

    // ========== SCHEDULE ROUTES ==========
    Route::prefix('schedule')->group(function () {
        Route::get('/year/{year?}', [ScheduleController::class, 'getYearSchedule']);
        Route::post('/holiday', [ScheduleController::class, 'addHoliday']);
    });

    // ========== EMPLOYEE ROUTES ==========
    Route::get('employees', [EmployeeController::class, 'index']);
    Route::get('employees/{id}', [EmployeeController::class, 'show']);
    Route::patch('employee/profile/{id}', [EmployeeProfileController::class, 'update']);
    Route::patch('employee/management/{id}', [EmployeeManagementController::class, 'update']);

    // ========== DEPARTMENT ROUTES ==========
    Route::get('departments', [DepartmentController::class, 'index']);
    Route::get('departments/{id}', [DepartmentController::class, 'show']);
    Route::get('departements', [DepartmentController::class, 'index']); // backward compatibility
    Route::post('departments', [DepartmentController::class, 'store']);
    Route::patch('departments/{id}', [DepartmentController::class, 'update']);
    Route::delete('departments/{id}', [DepartmentController::class, 'destroy']);

    // ========== POSITION ROUTES ==========
    Route::get('positions', [PositionController::class, 'index']);
    Route::get('positions/{id}', [PositionController::class, 'show']);
    Route::get('position/{userId}', [PositionController::class, 'show_position']);
    Route::post('positions', [PositionController::class, 'store']);
    Route::patch('positions/{id}', [PositionController::class, 'update']);
    Route::delete('positions/{id}', [PositionController::class, 'destroy']);

    // ========== LETTER (SURAT IZIN) ROUTES ==========
    Route::prefix('letters')->group(function () {
        Route::get('/', [LetterController::class, 'index']);
        Route::get('/formats', [LetterController::class, 'getAllFormats']); // GET /letters/formats
        Route::get('/{id}', [LetterController::class, 'show']);
        Route::post('/', [LetterController::class, 'store']);
        Route::put('/{id}/status', [LetterController::class, 'updateStatus']);
        Route::delete('/{id}', [LetterController::class, 'destroy']);
    });

    // ========== IZIN DASHBOARD ROUTES ==========
    Route::prefix('izin')->group(function () {
        Route::get('/dashboard', IzinDashboardController::class);
        Route::get('/list', [IzinDashboardController::class, 'izinList']);
        Route::get('/detail/{id}', [IzinDashboardController::class, 'IzinDetail']);
        Route::post('/update/{id}', [IzinDashboardController::class, 'updateStatus']);
        Route::get('/export-approved', [IzinDashboardController::class, 'exportApprovedLetters']);
    });

    // ========== TEMPLATE SURAT ROUTES ==========
    Route::prefix('templates')->group(function () {
        Route::get('/', [TemplateController::class, 'index']);
        Route::post('/', [TemplateController::class, 'store']);
        Route::get('/{id}', [TemplateController::class, 'show']);
        Route::put('/{id}', [TemplateController::class, 'update']);
        Route::delete('/{id}', [TemplateController::class, 'destroy']);
    });
});