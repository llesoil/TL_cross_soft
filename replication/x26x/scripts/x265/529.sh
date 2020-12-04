#!/bin/sh

numb='530'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 30 --keyint 210 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.0,1.0,0.8,0.2,0.7,0.1,2,1,16,30,210,2,20,50,5,4,63,28,1,2000,-1:-1,umh,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"