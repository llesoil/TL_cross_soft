#!/bin/sh

numb='1706'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 25 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.4,1.1,2.0,0.2,0.6,0.9,0,1,16,25,220,4,22,50,5,4,67,38,2,1000,-1:-1,hex,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"