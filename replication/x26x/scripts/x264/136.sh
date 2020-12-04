#!/bin/sh

numb='137'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 35 --keyint 240 --lookahead-threads 2 --min-keyint 23 --qp 0 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.5,1.3,4.0,0.5,0.7,0.4,0,2,6,35,240,2,23,0,4,1,69,18,1,1000,-2:-2,hex,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"