#!/bin/sh

numb='1651'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 0.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 35 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 0 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.3,1.0,0.2,0.5,0.6,0.7,1,0,0,35,220,4,22,0,4,0,63,28,3,2000,1:1,dia,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"