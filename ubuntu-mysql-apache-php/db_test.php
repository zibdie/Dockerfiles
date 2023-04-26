<?php
echo "<h1><b>Curl Test</b></h1>";

$options = array(
    CURLOPT_URL => "https://icanhazip.com/",
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => false,
    CURLOPT_SSL_VERIFYPEER => false,
    CURLOPT_FOLLOWLOCATION => true
);

$ch = curl_init();
curl_setopt_array($ch, $options);

$response = curl_exec($ch);
curl_close($ch);

echo $response;

echo "<h1><b>Database Test</b></h1>";
$con = mysqli_connect("127.0.0.1", "root", "root", "mydatabase", 3306);
if (mysqli_connect_errno()) {
    $err = "Failed to connect to MySQL: " . $con->connect_error;
    $rc = array('return_code' => -1, 'error_message' => $err);
    echo (json_encode($rc));
} else {
    $results = $con->query("SELECT * FROM `users`");
    $db_data = array();

    if ($results->num_rows > 0) {
        while ($row = $results->fetch_assoc()) {
            $data[] = $row;
        }
    } else {
        $data = array(
            'return_code' => 0,
            'error_message' => 'There are no users'
        );
    }
    echo (json_encode($data));
}


?>