#! /usr/bin/expect

spawn scp datos.csv jperalta@patana.esfm.ipn.mx:
expect "password"
send "jperalta\r"
interact
