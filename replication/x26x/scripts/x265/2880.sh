#!/bin/sh

numb='2881'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 40 --keyint 300 --lookahead-threads 1 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.5,1.5,1.4,0.4,0.4,0.8,0.9,1,0,2,40,300,1,25,30,4,3,60,28,6,2000,-1:-1,umh,show,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"