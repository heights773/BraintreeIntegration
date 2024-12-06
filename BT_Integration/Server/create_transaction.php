<?php
require '../../vendor/autoload.php';

$gateway = new Braintree\Gateway([
    'environment' => 'sandbox',
    'merchantId' => 'xnp6xtw7jt8cdytq',
    'publicKey' => '368ngzwh8z9r6fwt',
    'privateKey' => 'e9291a68785c8b4c6d45c3a71e68f687'
]);

$amount = $_POST['amount'];
$paymentMethodNonce =  $_POST['payment_method_nonce'];

$result = $gateway->transaction()->sale([
  'amount' => $amount,
  'paymentMethodNonce' => $paymentMethodNonce,
  'options' => [
    'submitForSettlement' => True,
    'storeInVaultOnSuccess' => True
  ]
]);

echo json_encode($result);
?>
