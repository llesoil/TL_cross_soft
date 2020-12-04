#!/bin/sh

numb='2360'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 35 --keyint 290 --lookahead-threads 1 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.0,1.0,0.2,0.3,0.6,0.5,0,1,6,35,290,1,25,50,5,3,62,48,6,2000,-2:-2,dia,crop,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"