#!/bin/sh

numb='2524'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 5.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 0 --keyint 280 --lookahead-threads 4 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.5,1.1,5.0,0.4,0.6,0.3,0,1,16,0,280,4,22,40,4,2,62,48,6,2000,-1:-1,dia,crop,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"