#!/bin/sh

numb='2721'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 50 --keyint 300 --lookahead-threads 4 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.5,1.0,4.8,0.5,0.7,0.8,2,2,12,50,300,4,30,40,4,3,69,18,3,2000,-1:-1,umh,crop,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"