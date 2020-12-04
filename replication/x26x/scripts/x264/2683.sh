#!/bin/sh

numb='2684'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.3,1.4,0.8,0.2,0.9,0.5,0,2,0,20,210,2,22,10,5,1,60,38,1,1000,-1:-1,umh,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"