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
    Schema::connection('sqlite')->create('ddn', function (Blueprint $table) {
      $table->id();
      $table->tinyText('filename')->unique();
      $table->tinyText('modelIdentCode'); // merujuk ke @modelIdentCode
      $table->tinyText('senderIdent'); // merujuk ke senderIdent code atau sudah di transform codenya, gunakan file config jika ingin transform
      $table->tinyText('receiverIdent'); // merujuk ke receiver code atau sudah di transform codenya, gunakan file config jika ingin transform
      $table->tinyText('yearOfDataIssue'); // merujuk ke @yearOfDataIssue
      $table->tinyText('seqNumber'); // merujuk ke @seqNumber

      $table->tinyText('year');
      $table->tinyText('month');
      $table->tinyText('day');
      
      $table->string('securityClassification');
      $table->bigInteger('brexDmRef'); // merujuk filename brex yang sama dengan table csdb
      $table->text('authorization'); //merujuk ke ddnStatus/authorization
      $table->text('remarks')->nullable(); //merujuk ke ddnStatus/remarks
      /**
       * merujuk ke dmlEntry. cara tulis: 
       * { "deliveryList: [filename1, filename2, filename3, ...], "mediaIdent" : {$label} }
       * jika tidak ada, isi dengan null
       */
      $table->json('ddnContent')->nullable(); 
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    //
  }
};
