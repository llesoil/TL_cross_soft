#!/bin/sh

numb='85'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 20 --keyint 240 --lookahead-threads 1 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.0,1.0,0.2,0.3,0.7,0.7,3,1,14,20,240,1,20,40,5,3,60,18,2,2000,1:1,dia,show,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"