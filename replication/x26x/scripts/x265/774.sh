#!/bin/sh

numb='775'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 30 --keyint 270 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.1,1.0,3.2,0.2,0.8,0.4,1,0,10,30,270,2,28,50,3,0,68,28,4,2000,-2:-2,umh,show,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"