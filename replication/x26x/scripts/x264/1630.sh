#!/bin/sh

numb='1631'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 15 --keyint 240 --lookahead-threads 2 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.2,1.2,1.0,0.2,0.9,0.8,3,0,12,15,240,2,30,20,3,3,65,48,6,2000,-2:-2,dia,crop,veryslow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"