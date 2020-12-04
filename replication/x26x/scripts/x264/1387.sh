#!/bin/sh

numb='1388'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 30 --keyint 250 --lookahead-threads 4 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.5,1.0,4.4,0.2,0.6,0.6,2,1,16,30,250,4,25,30,4,1,68,38,3,2000,-1:-1,hex,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"