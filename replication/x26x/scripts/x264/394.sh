#!/bin/sh

numb='395'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 30 --keyint 250 --lookahead-threads 3 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.5,1.4,0.4,0.4,0.7,0.6,0,1,0,30,250,3,26,50,5,0,60,38,2,1000,-1:-1,umh,crop,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"