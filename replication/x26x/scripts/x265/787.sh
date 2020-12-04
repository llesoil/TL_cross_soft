#!/bin/sh

numb='788'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 10 --keyint 280 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.6,1.0,1.0,0.5,0.8,0.4,1,2,10,10,280,0,22,0,3,2,63,38,6,1000,-1:-1,dia,crop,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"