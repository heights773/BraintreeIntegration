<?php
require '../../vendor/autoload.php';

$gateway = new Braintree\Gateway([
    'environment' => 'sandbox',
    'merchantId' => 'xnp6xtw7jt8cdytq',
    'publicKey' => '368ngzwh8z9r6fwt',
    'privateKey' => 'e9291a68785c8b4c6d45c3a71e68f687'
]);

$now = new Datetime();
$past = clone $now;
$past = $past->modify("-3 months");

$collection = $gateway->transaction()->search([
    Braintree\TransactionSearch::createdAt()->between($past, $now)
]);

foreach($collection as $transaction) {
    print_r($transaction->id . "   -   " . $transaction->creditCardDetails->cardType . "   -   $" . $transaction->amount . ", ");
}
?>
