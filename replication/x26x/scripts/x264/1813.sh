#!/bin/sh

numb='1814'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.6,1.1,2.0,0.3,0.6,0.1,3,2,10,0,260,2,30,10,3,1,63,48,3,2000,-1:-1,umh,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"