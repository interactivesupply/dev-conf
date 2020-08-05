<?php
function get_curl_remote_ips($fp) 
{
    rewind($fp);
    $str = fread($fp, 8192);
    $regex = '/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/';
    if (preg_match_all($regex, $str, $matches)) {
        return array_unique($matches[0]);  // Array([0] => 74.125.45.100 [2] => 208.69.36.231)
    } else {
        return false;
    }
}

$url = $_GET["url"];
$wrapper = fopen('php://temp', 'r+');
$ch = curl_init($url);
curl_setopt($ch, CURLOPT_VERBOSE, true);
curl_setopt($ch, CURLOPT_STDERR, $wrapper);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
$result = curl_exec($ch);
curl_close($ch);
$ips = get_curl_remote_ips($wrapper);
fclose($wrapper);

header('Access-Control-Allow-Origin: *');
// header('Access-Control-Allow-Origin: ' . $_GET["url"]);
header('Content-type: application/json');
$ip_value = is_array($ips) ? $ips[0] : '';
$return = array("ip" => $ip_value);
echo json_encode($return, true);
exit(); 
?>