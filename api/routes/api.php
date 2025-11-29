<?php

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\Api\EmployeeController;
use App\Http\Controllers\Api\EmployeeProfileController;
use App\Http\Controllers\Api\EmployeeManagementController;
use App\Http\Controllers\Api\PositionController;
use App\Http\Controllers\Api\DepartmentController;
use Illuminate\Support\Facades\Route;

// Auth routes
Route::post("/login", [AuthController::class, "login"]);
Route::post("/register", [AuthController::class, "register"])->middleware("auth:sanctum");

// User routes
Route::get("/user/{id}", [UserController::class, "show_user"]);

// Employee routes (read only)
Route::middleware('auth:sanctum')->group(function () {
    Route::get('employees', [EmployeeController::class, 'index']);
    Route::get('employees/{id}', [EmployeeController::class, 'show']);
    
    // Employee profile routes (for logged-in employee)
    Route::patch('employee/profile/{id}', [EmployeeProfileController::class, 'update']);
});

// Employee management routes (for admin only)
Route::middleware(['auth:sanctum'])->group(function () {
    // TODO: Add 'admin' middleware
    Route::patch('employee/management/{id}', [EmployeeManagementController::class, 'update']);
});

// Department routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('departments', [DepartmentController::class, 'index']);
    Route::get('departments/{id}', [DepartmentController::class, 'show']);
});

// Department management (admin only)
Route::middleware(['auth:sanctum'])->group(function () {
    // TODO: Add 'admin' middleware
    Route::post('departments', [DepartmentController::class, 'store']);
    Route::patch('departments/{id}', [DepartmentController::class, 'update']);
    Route::delete('departments/{id}', [DepartmentController::class, 'destroy']);
});

// Position routes
Route::apiResource('positions', PositionController::class)->middleware('auth:sanctum');