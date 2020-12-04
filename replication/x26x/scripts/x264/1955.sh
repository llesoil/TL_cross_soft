#!/bin/sh

numb='1956'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 5 --keyint 210 --lookahead-threads 3 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.1,1.0,1.4,0.3,0.9,0.5,3,2,0,5,210,3,22,30,4,3,61,38,1,2000,-2:-2,dia,show,medium,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"