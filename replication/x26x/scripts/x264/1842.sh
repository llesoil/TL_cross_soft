#!/bin/sh

numb='1843'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 30 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.5,1.4,3.6,0.6,0.8,0.2,3,0,14,30,230,0,23,30,5,3,63,48,4,2000,-1:-1,dia,show,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"