#!/bin/sh

numb='1554'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 35 --keyint 280 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.5,1.0,2.4,0.5,0.7,0.0,3,2,6,35,280,2,24,10,5,4,60,38,2,1000,-2:-2,dia,show,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"