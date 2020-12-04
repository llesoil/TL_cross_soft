#!/bin/sh

numb='1069'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 45 --keyint 220 --lookahead-threads 0 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.4,1.2,4.2,0.2,0.7,0.0,2,2,2,45,220,0,26,30,3,1,60,18,6,2000,1:1,hex,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"