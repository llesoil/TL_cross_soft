#!/bin/sh

numb='1730'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 0 --keyint 300 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.5,1.2,4.4,0.4,0.7,0.9,0,1,8,0,300,0,30,10,3,3,67,18,2,1000,-1:-1,umh,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"