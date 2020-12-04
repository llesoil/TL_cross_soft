#!/bin/sh

numb='411'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 35 --keyint 230 --lookahead-threads 4 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.1,1.3,0.8,0.2,0.7,0.7,2,1,4,35,230,4,21,30,3,2,62,48,4,1000,1:1,umh,crop,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"