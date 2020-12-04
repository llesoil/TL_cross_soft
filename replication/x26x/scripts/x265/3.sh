#!/bin/bash

numb='4'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="./video$numb.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 5 --keyint 200 --lookahead-threads 4 --min-keyint 20 --qp 20 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "real" $logfilename | sed 's/,/./; s/elapsed/,/ ; s/system/,/ ;s/real//; s/in/,/' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded// ; s/fps)// ; s/(/,/; s//,/' | cut -d "k" -f 1`
# clean
rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.4,1.2,1.0,0.3,0.9,0.4,1,2,4,5,200,4,20,20,4,4,66,38,1,2000,1:1,umh,show,superfast,40,psnr,"
csvLine+="$size,$time,$persec"
echo "$csvLine"