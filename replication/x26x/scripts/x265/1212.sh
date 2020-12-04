#!/bin/sh

numb='1213'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 5 --keyint 280 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.2,1.3,4.8,0.4,0.6,0.2,1,2,12,5,280,4,27,40,3,1,60,38,1,1000,-1:-1,umh,show,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"