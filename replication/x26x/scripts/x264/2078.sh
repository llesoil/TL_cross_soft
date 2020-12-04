#!/bin/sh

numb='2079'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 15 --keyint 200 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.5,1.4,2.0,0.5,0.8,0.8,2,0,10,15,200,2,28,20,5,3,61,38,3,1000,1:1,hex,crop,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"