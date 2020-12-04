#!/bin/sh

numb='1988'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 15 --keyint 250 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.0,1.3,4.6,0.4,0.8,0.2,2,1,6,15,250,4,30,20,4,3,69,48,1,1000,-1:-1,dia,crop,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"