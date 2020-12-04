#!/bin/sh

numb='663'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 15 --keyint 220 --lookahead-threads 4 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.0,1.4,2.4,0.5,0.6,0.6,2,0,8,15,220,4,21,30,5,4,61,28,6,1000,-1:-1,dia,crop,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"