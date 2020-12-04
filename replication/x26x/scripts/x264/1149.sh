#!/bin/sh

numb='1150'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 1.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.0,1.4,1.0,0.3,0.9,0.5,1,1,2,20,280,0,30,0,4,0,65,18,2,2000,-2:-2,hex,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"