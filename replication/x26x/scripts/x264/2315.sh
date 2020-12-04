#!/bin/sh

numb='2316'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 30 --keyint 300 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.0,1.5,1.0,1.0,0.2,0.8,0.1,1,2,10,30,300,1,25,20,3,2,66,38,4,1000,1:1,umh,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"