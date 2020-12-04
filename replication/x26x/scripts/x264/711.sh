#!/bin/sh

numb='712'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 20 --keyint 250 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.0,1.5,1.2,0.8,0.2,0.7,0.5,1,0,6,20,250,2,26,10,3,2,67,28,5,1000,-2:-2,dia,crop,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"