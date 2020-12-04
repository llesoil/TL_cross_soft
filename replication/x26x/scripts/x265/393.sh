#!/bin/sh

numb='394'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.0 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 20 --keyint 280 --lookahead-threads 1 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.3,1.2,2.0,0.4,0.9,0.1,0,2,10,20,280,1,22,0,5,1,69,48,6,2000,1:1,hex,show,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"