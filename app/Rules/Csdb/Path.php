<?php

namespace App\Rules\Csdb;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class Path implements ValidationRule
{
  /**
   * Run the validation rule.
   *
   * @param  \Closure(string): \Illuminate\Translation\PotentiallyTranslatedString  $fail
   */
  public function validate(string $attribute, mixed $path, Closure $fail): void
  {
    preg_match('/[^a-zA-Z1-9\/\s]+/', $path, $matches, PREG_OFFSET_CAPTURE, 0);
    if (!empty($matches)) {
      $fail('Path must match to /[^a-zA-Z1-9\/\s]+/');
    };
  }
}