#!/bin/sh

numb='1267'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 15 --keyint 250 --lookahead-threads 1 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.5,1.3,2.4,0.4,0.9,0.6,0,1,8,15,250,1,20,30,4,3,66,38,5,1000,-2:-2,dia,show,fast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"