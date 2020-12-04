#!/bin/sh

numb='314'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 25 --keyint 270 --lookahead-threads 2 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.5,1.0,1.0,2.8,0.3,0.9,0.7,2,2,12,25,270,2,28,30,3,0,65,28,5,2000,-2:-2,hex,crop,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"