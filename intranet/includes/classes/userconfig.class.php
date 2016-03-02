<?php

class UserConfig {
	var $id;
	var $lastUpdate;
	var $userId;
	var $urlGoogleTransitFeed;
	var $manageLayer;
	var $shareData;
	
	function UserConfig($userId) {
		$this->userId = $userId;
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
	function setUserId($userId) {
		$this->userId = $userId;
	}
	function getUserId() {
		return $this->userId;
	}
	function setUrlGoogleTransitFeed($urlGoogleTransitFeed) {
		$this->urlGoogleTransitFeed = $urlGoogleTransitFeed;
	}
	function getUrlGoogleTransitFeed() {
		return $this->urlGoogleTransitFeed;
	}
	function setManageLayer($manageLayer) {
		$this->manageLayer = $manageLayer;
	}
	function getManageLayer() {
		return $this->manageLayer;
	}
	function setShareData($shareData) {
		$this->shareData = $shareData;
	}
	function getShareData() {
		return $this->shareData;
	}
}

?>