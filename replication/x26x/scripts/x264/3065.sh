#!/bin/sh

numb='3066'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --intra-refresh --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,--slow-firstpass,--weightb,1.0,1.3,1.1,1.2,0.5,0.8,0.4,2,0,12,0,260,2,29,0,4,4,67,48,1,2000,-1:-1,dia,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"