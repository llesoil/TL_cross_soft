#!/bin/sh

numb='2769'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 35 --keyint 260 --lookahead-threads 1 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.3,1.1,3.0,0.4,0.6,0.6,1,0,2,35,260,1,29,40,4,4,66,18,3,1000,-1:-1,umh,show,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"