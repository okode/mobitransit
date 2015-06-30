<?php

include '../includes/classes/query.class.php';
include '../includes/classes/utils.class.php';

$query = new query();
$data = $_GET['data'];
$serviceId = $_GET['serviceid'];
$userId = $parameters['userid'];

$cryptUtil = new SICUCrypt();
$decrypted = $cryptUtil->decrypt($data);
$parameters = [];
parse_str($decrypted, $parameters);

$user = str_replace(chr(8), '', $parameters['useremail']);

// Enable in order to debug params received from the SUS AP
$debug = false;

$loggedUser = $query->findUserByEmail($user);

if ($loggedUser) {
	header("Location: http://www.mobitransit.com:8161/admin/send.jsp?JMSDestination=mobitransit.alerts&JMSDestinationType=topic");
} else {
	header("Location: ../index_sus.php?serviceid=" . $serviceId . "&userid=" . $userId . "&data=$data");
}

?>