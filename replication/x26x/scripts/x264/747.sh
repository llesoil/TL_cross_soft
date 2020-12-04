#!/bin/sh

numb='748'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 30 --keyint 250 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.1,1.4,1.4,0.6,0.9,0.4,3,0,2,30,250,0,23,10,3,4,67,48,4,2000,1:1,umh,crop,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"