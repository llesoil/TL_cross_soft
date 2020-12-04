#!/bin/sh

numb='722'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 40 --keyint 260 --lookahead-threads 2 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.5,1.4,1.4,4.0,0.6,0.6,0.5,2,1,12,40,260,2,24,50,5,1,60,18,4,1000,-1:-1,umh,crop,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"