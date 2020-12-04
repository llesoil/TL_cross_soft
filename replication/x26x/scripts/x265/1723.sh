#!/bin/sh

numb='1724'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 40 --keyint 260 --lookahead-threads 1 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.5,1.4,1.0,2.6,0.6,0.6,0.4,3,0,10,40,260,1,23,50,5,4,64,28,2,1000,1:1,dia,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"