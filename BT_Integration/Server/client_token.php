<?php
require '../../vendor/autoload.php';

$gateway = new Braintree\Gateway([
    'environment' => 'sandbox',
    'merchantId' => 'xnp6xtw7jt8cdytq',
    'publicKey' => '368ngzwh8z9r6fwt',
    'privateKey' => 'e9291a68785c8b4c6d45c3a71e68f687'
]);

$clientToken = $gateway->clientToken()->generate();
echo ($clientToken);
?>
