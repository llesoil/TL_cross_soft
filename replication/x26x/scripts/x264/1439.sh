#!/bin/sh

numb='1440'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 10 --keyint 270 --lookahead-threads 1 --min-keyint 23 --qp 30 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.5,1.0,1.0,1.0,0.6,0.7,0.9,3,1,6,10,270,1,23,30,5,3,63,38,1,1000,-1:-1,dia,show,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"