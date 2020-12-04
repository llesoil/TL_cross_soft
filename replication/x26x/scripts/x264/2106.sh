#!/bin/sh

numb='2107'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 15 --keyint 200 --lookahead-threads 3 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.5,1.1,1.8,0.3,0.7,0.5,2,1,14,15,200,3,21,10,4,4,68,28,6,2000,-2:-2,dia,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"