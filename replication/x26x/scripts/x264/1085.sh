#!/bin/sh

numb='1086'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 35 --keyint 250 --lookahead-threads 3 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.1,1.2,0.4,0.3,0.8,0.5,2,2,0,35,250,3,25,40,5,4,68,18,5,2000,1:1,dia,show,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"