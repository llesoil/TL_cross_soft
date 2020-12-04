#!/bin/sh

numb='1625'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 50 --keyint 230 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.1,1.2,4.4,0.2,0.6,0.4,2,2,0,50,230,2,28,50,4,3,60,48,5,1000,-1:-1,hex,crop,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"