<?php 

	/*
		SUSAP Integration Crypto Utility
		
		Simple mcrypt wrapper adapted to SUSAP specifications:
		- DES algorithm
		- CBC mode
		- PKCS7 padding
	
		Okode 2012
	*/
    class SICUCrypt
    {
    	// Configuration variables, it would be a good idea to move them to a configuration file
    	// and/or make them configurable through constructor. Both are provided at SUSAP backend.
        private $iv = 'AWARzTe8'; // Initialization vector
        private $key = 'elegante'; // Secret key

        function __construct()
        {
        }

        function encrypt($str) {

          $td = mcrypt_module_open(MCRYPT_DES, '', MCRYPT_MODE_CBC,'');

          mcrypt_generic_init($td, $this->key, $this->iv);

          $str = $this->padPKCS7(urlencode($str), mcrypt_enc_get_block_size($td));

          $encrypted = mcrypt_generic($td, $str);

          mcrypt_generic_deinit($td);
          mcrypt_module_close($td);

          return base64_encode($encrypted);
        }

        function decrypt($code) {

          $td = mcrypt_module_open(MCRYPT_DES, '', MCRYPT_MODE_CBC,'');

          mcrypt_generic_init($td, $this->key, $this->iv);

          $code = $this->unpadPKCS7($code,mcrypt_enc_get_block_size($td));

          $decrypted = mdecrypt_generic($td, base64_decode($code));

          mcrypt_generic_deinit($td);
          mcrypt_module_close($td);

          return urldecode(urldecode(utf8_encode(trim($decrypted))));
        }

        protected function hex2bin($hexdata) {
          $bindata = '';

          for ($i = 0; $i < strlen($hexdata); $i += 2) {
                $bindata .= chr(hexdec(substr($hexdata, $i, 2)));
          }

          return $bindata;
        }

		function unpadPKCS7($data, $blockSize) {
    		  $length = strlen ( $data );
    		  if ($length > 0) {
        		$first = substr ( $data, - 1 );

	         	if (ord ( $first ) <= $blockSize) {
            			for($i = $length - 2; $i > 0; $i --)
                		if (ord ( $data [$i] != $first ))
                    			break;

				return substr ( $data, 0, $i );
        		}
    		  }
    		  return $data;
		}


		function padPKCS7($text, $blockSize) {
		  $pad = $blockSize - (strlen($text) % $blockSize);
		  return $text . str_repeat(chr($pad), $pad);
		}

    }
?>
