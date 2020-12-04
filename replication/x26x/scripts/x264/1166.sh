#!/bin/sh

numb='1167'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 20 --keyint 270 --lookahead-threads 4 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.0,1.2,1.0,0.2,0.9,0.6,3,1,6,20,270,4,23,0,3,2,68,18,6,2000,-1:-1,dia,show,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"