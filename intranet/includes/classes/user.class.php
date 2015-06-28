<?php

class User {
	var $id;
	var $lastUpdate;
	var $email;
	
	/*function User() { }
	function User($email) {
		$this->email = $email;
	}*/
	function User($id, $lastUpdate, $email) {
		$this->id = $id;
		$this->lastUpdate = $lastUpdate;
		$this->email = $email;
	}
	
	function setId($id) {
		$this->id = $id;
	}
	function getId() {
		return $this->id;
	}
	function setLastUpdate($lastUpdate) {
		$this->lastUpdate = $lastUpdate;
	}
	function getLastUpdate() {
		return $this->lastUpdate;
	}
	function setEmail($email) {
		$this->email = $email;
	}
	function getEmail() {
		return $this->email;
	}
}

?>