#!/bin/sh

numb='279'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 45 --keyint 210 --lookahead-threads 1 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.0,1.4,0.4,0.2,0.8,0.4,0,0,16,45,210,1,20,0,4,3,63,18,4,2000,1:1,dia,show,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"