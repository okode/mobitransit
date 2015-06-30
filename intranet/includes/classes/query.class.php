<?php
include_once ('config.inc.php');
include_once('user.class.php');
include_once('userconfig.class.php');

class query {
	var $conn;

	function query() {

		try{
			
			$this->conn = @new mysqli(HOSTNAME, USERNAME, PASSWORD, DATABASE);
	
			//$this->lang = $lang;
			 
			if (mysqli_connect_errno()) {
				echo "La conexión a la BD ha fallado. Causa: " . mysqli_connect_errno();
				throw new Exception(DATABASE_CONNECTION_WARNING);
			}
			
			$this->conn->query("SET NAMES 'latin1'");
		} catch (Exception $e) {
			/*utils::send_alert($e->getMessage());
			utils::goback();*/
			exit();
		}
	}
	
	function close() {
		if ($this->conn)
			$this->conn->close();
	}
	/**
	 * 
	 * Find all Users.
	 */
	function findAllUsers() {
		$sentence = "SELECT c_id, c_lastupdate, c_email FROM t_user ORDER BY c_id ASC";
		$result = $this->conn->query($sentence);

		$users = array();
		while($row = $result->fetch_assoc())
			$users[] = new User($row['c_id'], $row['c_lastupdate'], $row['c_email']);

		return $users;
	}
	/**
	 * 
	 * Find user by email. Return null if user do not exists.
	 * @param $email User email.
	 */
	function findUserByEmail($email) {
		$email = str_replace(chr(8), '', $email); // The end of the email came with backspaces
		$emailEscape = $this->conn->real_escape_string($email);
		$sentence = "SELECT c_id, c_lastupdate, c_email FROM t_user WHERE c_email='$emailEscape'";
		$result = $this->conn->query($sentence);

		if($result->num_rows == 0)
			return null;

		$row = $result->fetch_assoc();

		$user = new User($row['c_id'], $row['c_lastupdate'], $row['c_email']);
		return $user;
	}
	/**
	 * 
	 * Insert registre for a new User.
	 * @param $userEmail email of the new user.
	 */
	function createNewUser($userEmail) {
		$userEscape = $this->conn->real_escape_string($userEmail);

		$sentence = "INSERT INTO t_user (c_email) " .
			"VALUES ('$userEscape')";
		$result = $this->conn->query($sentence);
		
		return $this->findUserByEmail($userEmail);
	}
	/**
	 * 
	 * Find user's configuration.
	 * @param $userId User's id.
	 */
	function findUserConfiguration($userId) {
		$sentence = "SELECT c_id, c_lastupdate, c_userid, c_url_gtf, c_manage_layer, c_share_data FROM t_userconfig WHERE c_userid='$userId'";
		$result = $this->conn->query($sentence);
		
		if($result->num_rows == 0)
			return null;

		$row = $result->fetch_assoc();

		$config = new UserConfig($row['c_userid']);
		$config->setId($row['c_id']);
		$config->setLastUpdate($row['c_lastupdate']);
		$config->setUrlGoogleTransitFeed($row['c_url_gtf']);
		$config->setManageLayer($row['c_manage_layer']);
		$config->setShareData($row['c_share_data']);
		return $config;
	}
	/**
	 * 
	 * Create empty user's configuration.
	 * @param $userId User's identifier
	 */
	function createNewUserConfig($userId) {
		$sentence = "INSERT INTO t_userconfig (c_userid, c_url_gtf, c_manage_layer, c_share_data) " .
			"VALUES ('$userId', '', 'FALSE', 'FALSE')";
		$result = $this->conn->query($sentence);
		
		return $this->findUserConfiguration($userId);
	}
	/**
	 * 
	 * Update user's configuration.
	 * @param $userId User's identifier
	 * @param $gtfUrl 
	 * @param $manageLayer
	 * @param $shareData
	 */
	function updateUserConfig($userId, $gtfUrl, $manageLayer, $shareData) {
		$sentence = "UPDATE t_userconfig SET c_url_gtf = '$gtfUrl', c_manage_layer = '$manageLayer', c_share_data = '$shareData' " .
			"WHERE c_userid = '$userId'";
		$result = $this->conn->query($sentence);
		
		return $this->findUserConfiguration($userId);
	}
}
?>