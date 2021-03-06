#!/bin/sh

numb='2376'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 40 --keyint 280 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.0,1.0,1.3,0.6,0.6,0.6,0.8,0,0,12,40,280,0,27,10,5,0,66,48,1,2000,1:1,hex,crop,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"