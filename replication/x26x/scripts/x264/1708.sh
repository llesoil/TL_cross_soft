#!/bin/sh

numb='1709'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 5 --keyint 210 --lookahead-threads 3 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.4,1.4,4.2,0.5,0.6,0.3,1,0,10,5,210,3,23,50,5,4,68,38,6,2000,1:1,hex,crop,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"