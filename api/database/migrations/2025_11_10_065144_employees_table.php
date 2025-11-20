<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create("employees", function (Blueprint $table) {
            $table->id("id")->primary();
            $table->unsignedBigInteger("user_id");
            $table->unsignedBigInteger("ck_settings_id")->nullable();
            $table->string("first_name", 100);
            $table->string("last_name", 100);
            $table->char("gender", 1);
            $table->text("address");
            $table
                ->foreign("user_id")
                ->references("id")
                ->on("users")
                ->onDelete("cascade");
            $table->timestamps();
        });
    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists("employees");
    }
};
