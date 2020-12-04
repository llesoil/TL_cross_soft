#!/bin/sh

numb='356'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 15 --keyint 230 --lookahead-threads 2 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset fast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.5,1.4,3.8,0.6,0.9,0.1,3,0,2,15,230,2,25,40,5,0,65,28,6,2000,-2:-2,dia,crop,fast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"