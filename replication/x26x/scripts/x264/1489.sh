#!/bin/sh

numb='1490'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 5.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 50 --keyint 280 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.6,1.2,5.0,0.2,0.8,0.4,1,0,4,50,280,3,29,0,4,4,65,18,6,1000,-2:-2,umh,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"