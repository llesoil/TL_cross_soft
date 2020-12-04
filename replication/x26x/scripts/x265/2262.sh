#!/bin/sh

numb='2263'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 0 --keyint 260 --lookahead-threads 4 --min-keyint 21 --qp 10 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,--slow-firstpass,--weightb,2.0,1.0,1.2,4.8,0.2,0.6,0.3,1,0,4,0,260,4,21,10,5,0,64,48,1,1000,1:1,hex,show,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"