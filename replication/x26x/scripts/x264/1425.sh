#!/bin/sh

numb='1426'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 5.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 40 --keyint 210 --lookahead-threads 4 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.4,1.2,5.0,0.5,0.6,0.6,0,1,2,40,210,4,20,40,4,2,62,18,1,2000,1:1,dia,crop,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"