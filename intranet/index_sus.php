<?php
include 'resources/header.php';
include 'includes/classes/query.class.php';
include 'includes/classes/utils.class.php';

$query = new query();
$data = $_GET['data'];
$serviceId = $_GET['serviceid'];

$cryptUtil = new SICUCrypt();
$decrypted = $cryptUtil->decrypt($data);
$parameters = [];
parse_str($decrypted, $parameters);

// Enable in order to debug params received from the SUS AP 
$debug = false;

?>
<div id="content" class="content">
	<div style="width: 100%; height: 30px;">
		<div id="column_left" class="column_left">
			Hello <strong><?php echo $parameters['username']?></strong>!,
		<br/><br/>
		Welcome to Mobitransit, the easiest way for transport agencies to reach their users with real-time information through amazing interfaces compatible with any computer or mobile device!
		
		<?php if ($debug) { ?>
			<br/><br/>
			Data: <?php echo $data?>
			<br/><br/>
			Data decrypted: <?php echo $decrypted; ?>
			<br/><br/>
			Parameters:
			<pre>
			<?php print_r($parameters); ?>
			</pre>
		<?php } ?>
		</div>
	</div>
	<div id="column_right" class="column_right">
		<?php
			$loggedUser = $query->findUserByEmail($user);
			if ($loggedUser) {
				echo "<a href=\"configurate.php?user=$user\" class=\"link\">Access your control panel</a>";
			} else { 
				echo "<a href=\"configurate.php?user=$user\" class=\"link\">Sign up now!</a>";
			}
		?>
		
		<?php
			include 'resources/footer.php';
		?>
	</div>
</div>
