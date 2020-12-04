#!/bin/sh

numb='3056'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 30 --keyint 260 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.3,1.4,4.8,0.6,0.7,0.4,3,1,14,30,260,4,30,50,5,3,66,28,1,1000,-2:-2,umh,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"