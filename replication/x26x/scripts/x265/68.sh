#!/bin/sh

numb='69'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 15 --keyint 200 --lookahead-threads 4 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.0,1.3,0.2,0.2,0.7,0.2,1,2,2,15,200,4,25,30,3,3,69,28,2,2000,-1:-1,hex,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"