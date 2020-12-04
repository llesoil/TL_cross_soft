#!/bin/sh

numb='682'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 45 --keyint 220 --lookahead-threads 0 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.6,1.2,0.4,0.4,0.8,0.6,3,2,10,45,220,0,30,40,4,4,68,28,5,2000,-1:-1,umh,show,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"