#!/bin/sh

numb='3038'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 40 --keyint 220 --lookahead-threads 3 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.5,1.2,2.6,0.3,0.9,0.5,2,0,12,40,220,3,22,30,4,3,67,48,5,2000,-1:-1,umh,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"