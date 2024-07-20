<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
  /**
   * Run the migrations.
   */
  public function up(): void
  {
    Schema::connection('sqlite')->create('pmc', function (Blueprint $table) {
      $table->id();
      $table->tinyText('filename')->unique();

      $table->tinyText('modelIdentCode');
      $table->tinyText('pmIssuer');
      $table->tinyText('pmNumber');
      $table->tinyText('pmVolume');
      $table->tinyText('languageIsoCode');
      $table->tinyText('countryIsoCode');
      $table->tinyText('issueNumber');
      $table->tinyText('inWork');

      $table->tinyText('year');
      $table->tinyText('month');
      $table->tinyText('day');
      
      $table->tinyText('pmTitle');
      $table->tinyText('shortPmTitle')->nullable();
      

      $table->string('securityClassification');
      $table->tinyText('responsiblePartnerCompany'); // merujuk ke responsiblePartnerCompany, bisa code atau textnya jika ada
      $table->tinyText('originator'); // merujuk ke originator, bisa code atau textnya jika ada
      $table->tinyText('applicability'); // merujuk ke originator, bisa code atau textnya jika ada
      $table->bigInteger('brexDmRef');
      $table->text('qa'); // isi last QA: 'unverified', 'first-...', 'second-...'
      $table->text('remarks')->nullable();
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    Schema::dropIfExists('pmc');
  }
};