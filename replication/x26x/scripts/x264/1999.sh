#!/bin/sh

numb='2000'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 0 --keyint 280 --lookahead-threads 0 --min-keyint 22 --qp 40 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.0,1.0,0.4,0.2,0.9,0.3,0,0,12,0,280,0,22,40,3,4,65,48,4,1000,-1:-1,umh,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"