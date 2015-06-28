<?php
include 'resources/header.php';
include 'includes/classes/query.class.php';

$query = new query();
$user = $_GET['user'];
?>
<div id="content" class="content">
	<div style="width: 100%; height: 30px;">
		<div id="column_left" class="column_left">
			Welcome to Mobitransit, the easiest way for transport agencies to reach their users with real-time information through amazing interfaces compatible with any computer or mobile device!
		</div>
	</div>
	<div id="column_right" class="column_right">
		<?php
		$loggedUser = $query->findUserByEmail($user);
		if ($loggedUser) 
			echo "<a href=\"configurate.php?user=$user\" class=\"link\">Access your control panel</a>";
		else 
			echo "<a href=\"configurate.php?user=$user\" class=\"link\">Sign up now!</a>";
		?>
		
		<?php
		include 'resources/footer.php';
		?>
	</div>
</div>