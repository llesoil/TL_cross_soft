#!/bin/sh

numb='361'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 0 --keyint 260 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.2,1.0,0.4,0.3,0.6,0.8,1,2,10,0,260,1,27,40,3,4,66,18,1,1000,-1:-1,dia,crop,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"