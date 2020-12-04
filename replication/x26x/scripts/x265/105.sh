#!/bin/sh

numb='106'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 50 --keyint 220 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.4,1.3,2.8,0.6,0.8,0.4,0,2,6,50,220,3,30,40,3,4,68,38,4,2000,-1:-1,umh,crop,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"