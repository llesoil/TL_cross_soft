#!/bin/sh

numb='2126'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 2.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 5 --keyint 230 --lookahead-threads 1 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.3,1.4,2.8,0.4,0.6,0.2,3,1,16,5,230,1,30,0,4,2,60,38,2,2000,1:1,umh,show,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"