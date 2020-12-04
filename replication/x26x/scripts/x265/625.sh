#!/bin/sh

numb='626'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 0 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 20 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.0,1.2,3.8,0.2,0.7,0.5,3,1,14,0,200,1,27,20,4,3,63,18,1,1000,-2:-2,umh,show,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"