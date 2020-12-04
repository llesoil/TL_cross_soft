#!/bin/sh

numb='2857'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 14 --crf 45 --keyint 200 --lookahead-threads 1 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.6,1.3,3.8,0.2,0.9,0.7,2,2,14,45,200,1,24,40,4,2,61,28,1,1000,1:1,umh,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"