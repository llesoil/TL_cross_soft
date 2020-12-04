#!/bin/sh

numb='256'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 50 --keyint 210 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.1,1.0,4.4,0.6,0.7,0.0,0,0,6,50,210,0,24,20,5,2,63,28,5,1000,-2:-2,dia,crop,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"