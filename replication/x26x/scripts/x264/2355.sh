#!/bin/sh

numb='2356'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --intra-refresh --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 20 --keyint 300 --lookahead-threads 1 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,None,None,--no-weightb,2.0,1.3,1.4,3.4,0.3,0.6,0.2,2,0,12,20,300,1,20,40,5,1,61,48,1,2000,-2:-2,hex,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"