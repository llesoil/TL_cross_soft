#!/bin/sh

numb='2182'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 0 --keyint 240 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.6,1.3,0.2,0.2,0.7,0.1,3,2,16,0,240,0,22,20,3,3,63,28,5,2000,1:1,hex,crop,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"