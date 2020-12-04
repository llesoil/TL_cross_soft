#!/bin/sh

numb='2240'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 20 --keyint 270 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--no-weightb,0.0,1.1,1.2,4.0,0.3,0.6,0.8,3,0,6,20,270,0,25,50,4,0,61,18,1,2000,-1:-1,umh,show,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"