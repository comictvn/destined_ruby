<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
class CreateSocialMediaTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->timestamps();
            $table->string('email')->unique();
            $table->string('password');
            $table->string('name');
            $table->integer('age');
            $table->string('gender');
            $table->string('location');
            $table->text('preferences');
            $table->string('profile_picture');
            $table->text('bio');
        });
        Schema::table('social_media', function (Blueprint $table) {
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
        });
    }
    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
}
