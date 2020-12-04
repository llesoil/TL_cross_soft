#!/bin/sh

numb='2221'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 30 --keyint 300 --lookahead-threads 0 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.2,1.1,3.6,0.4,0.8,0.4,2,0,10,30,300,0,28,40,4,0,66,48,1,2000,-2:-2,hex,crop,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"