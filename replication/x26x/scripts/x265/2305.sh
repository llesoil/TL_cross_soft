#!/bin/sh

numb='2306'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 20 --keyint 210 --lookahead-threads 1 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.0,1.1,2.4,0.5,0.6,0.5,2,0,4,20,210,1,27,10,4,1,65,48,2,1000,-2:-2,hex,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"