#!/bin/sh

numb='1030'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 5 --keyint 240 --lookahead-threads 3 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.2,1.0,2.4,0.4,0.7,0.4,2,2,10,5,240,3,24,10,3,4,62,18,4,2000,-2:-2,hex,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"