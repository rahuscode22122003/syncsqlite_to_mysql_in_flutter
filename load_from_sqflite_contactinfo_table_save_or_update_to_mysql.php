<?php
include 'config.php';

// Sanitize inputs to prevent SQL injection
$userId = mysqli_real_escape_string($db, $_POST['userId']); // Corrected parameter name
$contact_id = mysqli_real_escape_string($db, $_POST['contact_id']);
$name = mysqli_real_escape_string($db, $_POST['name']);
$email = mysqli_real_escape_string($db, $_POST['email']);
$gender = mysqli_real_escape_string($db, $_POST['gender']);
$createdAt = mysqli_real_escape_string($db, $_POST['createdAt']); // Corrected parameter name

// Check if the record exists
$selectExists = $db->prepare("SELECT * FROM contactinfotable WHERE userId =? AND contact_id =?");
$selectExists->bind_param("ss", $userId, $contact_id);
$selectExists->execute();
$result = $selectExists->get_result();

$count = $result->num_rows;
if($count > 0){
  
    $update = $db->prepare("UPDATE contactinfotable SET name =?, email =?, gender =?, createdAt =? WHERE contact_id =? AND userId =?");
    $update->bind_param("ssssss", $name, $email, $gender, $createdAt, $contact_id, $userId);
    $update->execute();
    echo json_encode(array("message"=>"UPDATE Success"));
} else {
    // Record does not exist, insert it
    $insert = $db->prepare("INSERT INTO contactinfotable(contact_id,userId,name,email,gender,createdAt) VALUES(?,?,?,?,?,?)");
    $insert->bind_param("ssssss", $contact_id, $userId, $name, $email, $gender, $createdAt);
    $insert->execute();
    echo json_encode(array("message"=>"INSERT Success"));
}
?>
