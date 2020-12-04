#!/bin/sh

numb='675'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 50 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.0,1.3,3.0,0.2,0.7,0.1,2,2,12,50,300,2,21,30,4,0,64,18,5,2000,-1:-1,hex,show,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"