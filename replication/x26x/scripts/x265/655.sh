#!/bin/sh

numb='656'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 5.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 40 --keyint 290 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.0,1.3,5.0,0.2,0.9,0.7,0,2,0,40,290,3,20,10,4,1,69,18,1,2000,-1:-1,umh,crop,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"