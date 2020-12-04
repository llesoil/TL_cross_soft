#!/bin/sh

numb='526'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 50 --keyint 240 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.3,1.3,3.8,0.3,0.8,0.3,2,1,6,50,240,2,28,40,3,0,65,38,1,1000,-2:-2,dia,crop,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"