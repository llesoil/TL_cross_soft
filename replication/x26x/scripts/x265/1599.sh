#!/bin/sh

numb='1600'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 30 --keyint 230 --lookahead-threads 0 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.0,1.0,1.6,0.6,0.8,0.0,2,2,12,30,230,0,25,30,5,2,64,38,2,1000,1:1,umh,crop,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"