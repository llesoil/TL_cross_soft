#!/bin/sh

numb='617'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 45 --keyint 280 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.1,1.3,2.6,0.3,0.7,0.7,0,1,12,45,280,2,28,20,3,2,61,38,2,2000,-1:-1,dia,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"