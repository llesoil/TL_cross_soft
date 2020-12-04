#!/bin/sh

numb='2397'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 5 --keyint 250 --lookahead-threads 0 --min-keyint 22 --qp 10 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.5,1.3,3.8,0.4,0.6,0.4,0,2,6,5,250,0,22,10,4,1,66,28,5,1000,-1:-1,hex,crop,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"