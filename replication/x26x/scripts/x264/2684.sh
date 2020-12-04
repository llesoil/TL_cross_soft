#!/bin/sh

numb='2685'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 30 --keyint 280 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.5,1.3,3.8,0.4,0.9,0.0,0,1,14,30,280,1,27,30,4,2,66,38,6,2000,-2:-2,hex,crop,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"