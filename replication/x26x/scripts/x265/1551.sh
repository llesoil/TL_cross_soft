#!/bin/sh

numb='1552'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 10 --keyint 200 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.0,3.8,0.4,0.7,0.0,1,0,16,10,200,1,30,40,5,0,62,28,4,2000,1:1,umh,crop,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"