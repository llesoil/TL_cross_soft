#!/bin/sh

numb='717'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 10 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.0,1.4,1.8,0.5,0.9,0.8,2,1,16,10,210,3,24,0,5,3,63,28,2,2000,-2:-2,dia,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"