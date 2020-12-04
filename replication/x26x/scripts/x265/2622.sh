#!/bin/sh

numb='2623'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 25 --keyint 300 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.4,1.3,4.8,0.5,0.8,0.5,3,1,16,25,300,0,23,10,5,3,65,38,1,2000,-2:-2,umh,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"