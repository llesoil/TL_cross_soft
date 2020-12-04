#!/bin/sh

numb='873'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 50 --keyint 210 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.4,1.3,1.8,0.4,0.8,0.4,2,0,14,50,210,0,24,0,5,4,60,38,3,1000,-2:-2,hex,show,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"