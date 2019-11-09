<?php

    class Constants
    {
        static $DB_SERVER = 'localhost';
        static $DB_NAME = 'id11511244_jeepjeep';
        static $USERNAME = 'id11511244_driver';
        static $PASSWORD = 'password';

        static $SQL_SELECT_ALL = 'SELECT * FROM jeepney';
    }

    class Jeep
    {
        public function connect()
        {
            $con = new mysqli(Constants::$DB_SERVER,Constants::$USERNAME,Constants::$PASSWORD,Constants::$DB_NAME);
            if($con->connect_error)
            {
                return null;
            }
            else
            {
                return $con;
            }
        }

        public function select()
        {
            $con = $this->connect();
            if($con != null)
            {
                $result = $con->query(Constants::$SQL_SELECT_ALL);
                if($result->num_rows>0)
                {
                    $jeepneys=array();
                    while($row=$result->fetch_array())
                    {
                        array_push($jeepneys, array("id"=>$row['Id'], "lat"=>$row['lat'], "lng"=>$row['lng'], "passengers"=>$row['passengers']));
                    }
                    print(json_encode(array_reverse($jeepneys)));
                }
                else
                {
                    print(json_encode(array("PHP EXCEPTION : CAN'T RETRIEVE FROM MYSQL.")));
                }
                $con->close();
            }
            else
            {
                print(json_encode(array("PHP EXCEPTION : CAN'T CONNECT TO MYSQL. NULL CONNECTION.")));
            }
        }
    }

    $jeepneys = new Jeep();
    $jeepneys->select();
?>