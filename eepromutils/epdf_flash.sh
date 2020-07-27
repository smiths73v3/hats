#!/bin/bash
echo Build eeprom utilities required to read/write eeprom
make > /dev/null
rm readback.* >/dev/null

echo generating epdf.eep from epdf.txt file
./eepmake epdf.txt epdf.eep >/dev/null

i=-1
x=0
while [ $i -ne 0 ]; do
    #read back eeprom and see if flash was successful
    ./eepflash.sh -t=24c32 -r -y -f=readback.eep >/dev/null
    ./eepdump readback.eep readback.txt >/dev/null
    grep "EPDF" readback.txt >/dev/null
    i=$?
    ((x+=1))
    if [ $i -eq 0 ]; then
      echo SUCCESS!
      exit
    fi
    echo flashing epdf.eep to eeprom on hat attempt $x
    ####--./eepflash.sh -t=24c32 -w -y -f=epdf.eep 
    #if not, reflash until a success is seen.
    sleep 1 
 done


