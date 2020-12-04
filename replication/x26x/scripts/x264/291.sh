#!/bin/sh

numb='292'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 0.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 20 --keyint 300 --lookahead-threads 4 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.3,0.6,0.4,0.9,0.2,1,0,4,20,300,4,27,10,4,4,68,48,2,2000,-2:-2,umh,crop,fast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"