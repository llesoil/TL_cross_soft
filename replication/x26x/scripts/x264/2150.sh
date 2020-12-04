#!/bin/sh

numb='2151'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 25 --keyint 270 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset medium --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.6,1.1,3.2,0.5,0.8,0.1,3,2,2,25,270,1,28,50,4,3,61,18,4,1000,1:1,hex,show,medium,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"