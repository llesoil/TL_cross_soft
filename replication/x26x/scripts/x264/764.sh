#!/bin/sh

numb='765'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 45 --keyint 280 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.6,1.4,3.8,0.4,0.6,0.6,3,1,2,45,280,3,29,10,3,0,62,48,1,1000,-2:-2,umh,crop,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"