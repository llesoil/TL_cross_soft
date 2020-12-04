#!/bin/sh

numb='949'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 40 --keyint 260 --lookahead-threads 4 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.0,1.0,1.0,0.5,0.8,0.3,2,0,12,40,260,4,28,10,5,3,67,18,2,2000,1:1,hex,show,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"