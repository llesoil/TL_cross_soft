#!/bin/sh

numb='655'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 35 --keyint 250 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.3,1.4,2.0,0.4,0.6,0.9,2,1,12,35,250,2,28,20,5,3,60,48,1,2000,-1:-1,umh,crop,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"