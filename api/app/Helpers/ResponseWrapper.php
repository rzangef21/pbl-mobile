<?php

namespace App\Helpers;

class ResponseWrapper
{
    public static function make(
        string $message,
        int $status,
        array|null $data,
        array|null $errors,
    ) {
        if (!is_null($errors)) {
            return response()->json(
                ["message" => $message, "errors" => $errors],
                $status,
            );
        }

        return response()->json(
            ["message" => $message, "data" => $data],
            $status,
        );
    }
}
