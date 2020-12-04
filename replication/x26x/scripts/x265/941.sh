#!/bin/sh

numb='942'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 40 --keyint 210 --lookahead-threads 1 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.4,1.0,1.0,0.4,0.8,0.3,2,0,16,40,210,1,29,0,3,3,63,48,3,1000,-2:-2,hex,crop,ultrafast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"