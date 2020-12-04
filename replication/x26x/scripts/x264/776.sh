#!/bin/sh

numb='777'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 15 --keyint 220 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.1,1.0,0.4,0.9,0.9,0,1,2,15,220,3,30,20,4,1,69,48,2,2000,-1:-1,dia,show,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"