#!/bin/sh

numb='1786'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 20 --keyint 240 --lookahead-threads 1 --min-keyint 25 --qp 40 --qpstep 4 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.0,1.2,1.1,1.2,0.4,0.6,0.5,0,2,12,20,240,1,25,40,4,4,63,48,3,2000,-1:-1,hex,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"