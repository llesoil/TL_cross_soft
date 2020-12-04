#!/bin/sh

numb='3080'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 30 --keyint 260 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.3,1.4,2.2,0.2,0.8,0.9,3,2,14,30,260,1,27,40,4,4,65,18,5,1000,-1:-1,dia,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"