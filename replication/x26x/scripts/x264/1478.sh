#!/bin/sh

numb='1479'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 5 --keyint 210 --lookahead-threads 1 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.5,1.0,1.0,2.4,0.2,0.6,0.1,1,2,8,5,210,1,25,50,3,4,61,18,5,2000,-1:-1,hex,crop,slower,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"