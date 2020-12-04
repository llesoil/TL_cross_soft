#!/bin/sh

numb='1912'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 35 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.4,3.8,0.4,0.7,0.0,0,1,16,35,210,3,24,20,4,0,60,28,4,2000,-2:-2,umh,crop,medium,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"