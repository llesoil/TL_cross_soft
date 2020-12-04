#!/bin/sh

numb='557'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 5.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 45 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.5,1.1,5.0,0.6,0.8,0.2,0,1,16,45,300,3,24,20,4,3,64,38,4,2000,-1:-1,hex,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"