#!/bin/sh

numb='1904'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 35 --keyint 290 --lookahead-threads 4 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.0,1.2,0.2,0.4,0.9,0.9,0,1,12,35,290,4,24,50,3,1,68,18,5,2000,-2:-2,dia,crop,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"