#!/bin/sh

numb='1467'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 1.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 35 --keyint 270 --lookahead-threads 1 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.6,1.1,1.2,0.5,0.8,0.5,2,0,6,35,270,1,28,20,5,0,64,28,3,1000,-2:-2,dia,show,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"