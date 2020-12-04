#!/bin/sh

numb='999'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 45 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.6,1.1,4.2,0.6,0.7,0.2,1,1,8,45,260,2,28,10,3,0,61,18,5,2000,-2:-2,hex,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"