<?php

    try{
        $db = new PDO ('mysql:host=localhost;dbname=id11511244_jeepjeep','id11511244_driver','password');
    //  echo 'connected';
    }
    catch( PDOException $e){
        $error = $e->getMessage();
        echo ($error);
    }
?>
