#!/bin/sh

numb='2965'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 25 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.0,1.4,1.1,0.4,0.5,0.8,0.6,0,1,6,25,200,1,27,20,3,1,69,18,2,1000,1:1,dia,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"