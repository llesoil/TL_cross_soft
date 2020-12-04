#!/bin/sh

numb='2777'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 45 --keyint 290 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.3,1.1,4.4,0.2,0.9,0.4,2,0,2,45,290,1,28,50,4,2,65,28,4,2000,-1:-1,hex,crop,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"