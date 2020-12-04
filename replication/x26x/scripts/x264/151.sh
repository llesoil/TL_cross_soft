#!/bin/sh

numb='152'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 5.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 30 --keyint 200 --lookahead-threads 3 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,2.5,1.0,1.0,5.0,0.3,0.8,0.5,1,1,12,30,200,3,24,30,4,4,69,28,3,2000,1:1,umh,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"