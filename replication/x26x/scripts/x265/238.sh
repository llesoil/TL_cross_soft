#!/bin/sh

numb='239'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 30 --keyint 210 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.5,1.2,1.2,4.8,0.5,0.6,0.7,0,1,8,30,210,1,22,40,4,2,67,38,2,1000,-2:-2,umh,show,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"