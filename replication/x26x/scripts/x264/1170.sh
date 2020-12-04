#!/bin/sh

numb='1171'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 0 --keyint 280 --lookahead-threads 3 --min-keyint 27 --qp 20 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.6,1.1,3.8,0.5,0.7,0.3,1,0,10,0,280,3,27,20,5,2,68,48,5,1000,-1:-1,dia,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"