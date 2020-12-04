#!/bin/sh

numb='685'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 20 --keyint 270 --lookahead-threads 2 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.1,1.1,2.2,0.2,0.8,0.5,1,1,6,20,270,2,25,50,3,4,63,18,5,2000,-1:-1,dia,crop,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"