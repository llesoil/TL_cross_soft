#!/bin/sh

numb='1976'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 40 --keyint 280 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.0,1.0,4.2,0.5,0.7,0.6,3,1,8,40,280,3,23,30,4,3,60,38,5,2000,1:1,umh,show,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"