#!/bin/sh

numb='300'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 40 --keyint 230 --lookahead-threads 2 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.3,1.0,2.0,0.6,0.9,0.7,1,0,10,40,230,2,20,30,4,4,62,48,2,2000,-1:-1,dia,show,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"