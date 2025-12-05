<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseWrapper;
use App\Http\Controllers\Controller;
use App\Models\Employee;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $validated = $request->validate([
            "email" => "required|email|max:255",
            "password" => "required|max:255|string",
            "device_name" => "required|max:255|string",
        ]);

        $user = User::where("email", $validated["email"])->first();

        if (!$user || !Hash::check($validated["password"], $user["password"])) {
            throw ValidationException::withMessages([
                "email" => ["The provided credentials are incorrect."],
            ]);
        }
        $token = $user->createToken($validated["device_name"])->plainTextToken;
        return ResponseWrapper::make(
            "Login Sukses",
            200,
            true,
            [
                "token" => $token,
                "user_id" => $user["id"],
                "is_admin" => $user["is_admin"],
            ],
            null,
        );
    }

    public function register(Request $request)
    {
        try {
            $validated = $request->validate([
                "email" => "required|email|max:255",
                "password" => "required|max:255|string",
                "first_name" => "required|max:225|string",
                "last_name" => "required|max:225|string",
                "gender" => "required|string|max:1",
                "address" => "required|max:225|string",
                "position_id" => "required|int",
                "department_id" => "required|int",
            ]);

            $userCreated = User::create([
                "email" => $validated["email"],
                "password" => Hash::make($validated["password"]),
            ]);

            Employee::create([
                "first_name" => $validated["first_name"],
                "last_name" => $validated["last_name"],
                "gender" => $validated["gender"],
                "address" => $validated["address"],
                "user_id" => $userCreated["id"],
                "department_id" => $validated["department_id"],
                "position_id" => $validated["position_id"],
            ]);

            return ResponseWrapper::make(
                "Akun berhasil dibuat",
                201,
                true,
                null,
                null,
            );
        } catch (\Error $err) {
            Log::debug($err, "Register");
            return ResponseWrapper::make(
                "Akun gagal dibuat",
                500,
                false,
                null,
                $err->getMessage(),
            );
        }
    }
}
