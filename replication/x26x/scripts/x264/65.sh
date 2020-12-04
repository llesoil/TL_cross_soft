#!/bin/sh

numb='66'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 0.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 40 --keyint 270 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.6,1.0,0.4,0.4,0.7,0.0,3,0,4,40,270,3,30,20,5,2,67,48,2,2000,1:1,umh,show,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"