#!/bin/sh

numb='2246'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.6,1.1,4.4,0.3,0.7,0.3,3,2,8,45,220,1,21,20,3,0,62,38,6,2000,1:1,dia,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"