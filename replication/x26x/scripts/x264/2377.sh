#!/bin/sh

numb='2378'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 35 --keyint 210 --lookahead-threads 3 --min-keyint 21 --qp 10 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.1,1.2,0.2,0.3,0.6,0.6,1,2,6,35,210,3,21,10,3,0,67,48,1,1000,1:1,hex,crop,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"