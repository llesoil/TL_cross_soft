#!/bin/sh

numb='1817'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 30 --keyint 250 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.0,1.1,1.4,0.3,0.8,0.9,1,2,14,30,250,4,23,20,5,2,69,18,2,2000,1:1,dia,show,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"