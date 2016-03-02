<?php
include 'resources/header.php';
include 'includes/classes/query.class.php';
include 'includes/classes/utils.class.php';

$query = new query();

$user = $_GET['user'];
$serviceId = $_GET['serviceId'];
$userId = $_GET['userId'];

$loggedUser = $query->findUserByEmail($user);
$newUser = $loggedUser == null;
if ($newUser) {
	$susResult = sendSUSAPRegisterConfirmation($serviceId, $userId);
	error_log("SUS AP registration: " . $susResult);
	$loggedUser = $query->createNewUser($user);
}
	
$loggedUserConfig = $query->findUserConfiguration($loggedUser->id);
if ($loggedUserConfig == NULL)
	$loggedUserConfig = $query->createNewUserConfig($loggedUser->id);

@$action = $_GET['action'];	
@$gtfUrl = $_POST['gtfUrl'];
@$manageLayer = $_POST['manageLayer'];
@$shareData = $_POST['shareData'];
if ($action != null) {
	$manageLayer = $manageLayer == NULL ? FALSE : TRUE;
	$shareData = $shareData == NULL ? FALSE : TRUE;
	$loggedUserConfig = $query->updateUserConfig($loggedUser->id, (string)$gtfUrl, $manageLayer, $shareData);
}	

?>
<div class="column_left" id="control_panel_welcome">
Welcome to Mobitransit Control Panel, following the next steps you will be able to publish your transport information through our platforms. Use the register button to start processing your data, we will contact you through the process to keep you up to date.
</div>

<div id="configure_form" class="configure_form">
<?php
echo "<form action=\"configurate.php?user=$user&action=update\" method=\"post\">";
?>
	<ul>
		<li class="li_header"> Publish your static information using your Google Transit Feed</li>
<?php
	echo "<div class=\"li_subitem\">GTF repository URL: <input type=\"text\" name=\"gtfUrl\" class=\"li_input\" value=\"{$loggedUserConfig->urlGoogleTransitFeed}\"/></div>";
	echo "<li class=\"li_header\"> Manage your real time transport layer</li>"; 
	if($loggedUserConfig->manageLayer == 1)
 		echo "<div class=\"li_subitem\"><input class=\"li_chk\" type=\"checkbox\" name=\"manageLayer\" checked=\"checked\"/> Active</div>";
 	else 
 		echo "<div class=\"li_subitem\"><input class=\"li_chk\" type=\"checkbox\" name=\"manageLayer\"/> Active</div>";
?>
	<div class="li_note">
		Download our SDK to publish to the real time bus <a class="link" style="padding-right: 0px;" href="">here</a>
	</div>
	<div class="li_note">
		Contact <a class="link" style="padding-right: 0px;" href="mailto:info@mobitransit.com">us</a> if you need our professional services
	</div>
<?php
 	if ($loggedUserConfig->shareData == 1)
 		echo "<div class=\"li_subitem\"><input class=\"li_chk\" type=\"checkbox\" name=\"shareData\" checked=\"checked\"/> Allow data to be used in other services from SUS AP</div>";
 	else 
 		echo "<div class=\"li_subitem\"><input class=\"li_chk\" type=\"checkbox\" name=\"shareData\"/> Allow data to be used in other services from SUS AP</div>";
?>
		<div class="li_note">
				We will contact you for any suitable integration with other services, so you will always know any use of your data and the permission could be declined at any time.
		</div>
<?php	
 	if ($newUser)
 		echo "<div style=\"padding-top: 22px;\"><input class=\"configure_submit\" type=\"submit\" title=\"Register!\" value=\"Publish!\"/></div>";
 	else 
 		echo "<div style=\"padding-top: 22px;\"><input class=\"configure_submit\" type=\"submit\" title=\"Update\" value=\"Update\" /></div>";
?>
		<div class="li_note" style="margin-top: 4px; margin-left: 0px;">
			Start or update your service. We will contact you in order to send your URL for web page integrations and information about your city in our mobile apps.
		</div>
 	</ul>
</form>
</div>

<div class="column_left" id="contact_us">Please, don’t hesitate to contact us at <a class="link" style="padding-right: 0px;" href="mailto:info@mobitransit.com">info@mobitransit.com</a> to ask for help or aditional information.
</div>