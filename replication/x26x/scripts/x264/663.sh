#!/bin/sh

numb='664'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 0.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 25 --keyint 280 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.3,1.2,0.2,0.2,0.9,0.6,1,0,14,25,280,0,27,10,3,2,67,38,5,1000,-1:-1,hex,crop,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"