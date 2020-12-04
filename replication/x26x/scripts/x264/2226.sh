#!/bin/sh

numb='2227'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 50 --keyint 300 --lookahead-threads 1 --min-keyint 26 --qp 30 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.6,1.4,3.2,0.2,0.6,0.8,1,2,10,50,300,1,26,30,5,1,63,28,4,2000,-2:-2,dia,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"