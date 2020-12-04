#!/bin/sh

numb='1287'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 35 --keyint 280 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.0,1.3,0.8,0.2,0.7,0.9,0,1,2,35,280,0,28,10,4,4,61,38,4,2000,-1:-1,umh,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"