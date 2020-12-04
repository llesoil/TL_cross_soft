#!/bin/sh

numb='2241'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 45 --keyint 240 --lookahead-threads 3 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.0,1.4,1.8,0.3,0.8,0.1,2,2,2,45,240,3,21,30,4,3,60,48,2,1000,-2:-2,dia,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"