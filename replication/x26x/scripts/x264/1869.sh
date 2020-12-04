#!/bin/sh

numb='1870'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.6,1.2,2.0,0.3,0.9,0.0,0,2,16,10,240,4,28,10,5,4,60,48,4,1000,-1:-1,umh,show,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"