#!/bin/sh

numb='1223'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 10 --keyint 210 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.4,1.0,3.0,0.4,0.6,0.8,0,0,6,10,210,0,23,30,4,0,64,18,6,2000,-2:-2,hex,crop,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"