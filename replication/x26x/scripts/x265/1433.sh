#!/bin/sh

numb='1434'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 45 --keyint 280 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.5,1.2,2.0,0.3,0.6,0.6,3,2,14,45,280,1,23,20,3,2,66,38,2,2000,-1:-1,dia,crop,ultrafast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"