#!/bin/sh

numb='2900'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --intra-refresh --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 20 --keyint 290 --lookahead-threads 2 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,None,None,--no-weightb,1.5,1.4,1.3,3.0,0.3,0.7,0.0,1,2,12,20,290,2,30,30,5,3,62,18,1,1000,-2:-2,dia,crop,superfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"