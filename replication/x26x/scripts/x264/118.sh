#!/bin/sh

numb='119'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 35 --keyint 280 --lookahead-threads 1 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.1,1.3,2.4,0.6,0.8,0.7,2,2,2,35,280,1,21,50,4,0,61,18,3,1000,-1:-1,umh,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"