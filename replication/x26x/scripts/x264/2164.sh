#!/bin/sh

numb='2165'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 50 --keyint 210 --lookahead-threads 2 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.6,1.4,4.2,0.2,0.7,0.2,3,2,10,50,210,2,23,30,3,4,62,48,1,2000,1:1,dia,show,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"