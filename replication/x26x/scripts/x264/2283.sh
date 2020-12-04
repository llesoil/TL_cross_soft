#!/bin/sh

numb='2284'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 45 --keyint 210 --lookahead-threads 1 --min-keyint 21 --qp 10 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.2,1.1,3.4,0.3,0.7,0.8,3,1,14,45,210,1,21,10,5,4,62,18,5,1000,-1:-1,dia,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"