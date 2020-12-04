#!/bin/sh

numb='1359'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 35 --keyint 240 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.2,1.1,0.8,0.6,0.6,0.7,1,0,12,35,240,0,20,40,4,2,61,38,4,1000,-2:-2,dia,crop,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"