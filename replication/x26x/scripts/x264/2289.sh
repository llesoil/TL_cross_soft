#!/bin/sh

numb='2290'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 10 --keyint 300 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 3 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,3.0,1.4,1.3,4.4,0.5,0.8,0.4,3,1,12,10,300,0,21,30,3,3,64,28,4,2000,-1:-1,hex,crop,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"