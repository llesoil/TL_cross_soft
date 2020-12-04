#!/bin/sh

numb='2957'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 30 --keyint 300 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.1,1.0,1.2,0.5,0.7,0.6,1,2,12,30,300,4,28,0,4,0,62,18,3,2000,1:1,umh,crop,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"