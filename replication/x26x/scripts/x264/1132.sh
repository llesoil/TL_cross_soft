#!/bin/sh

numb='1133'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 10 --keyint 210 --lookahead-threads 0 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.0,1.3,4.4,0.5,0.6,0.9,1,0,4,10,210,0,28,30,3,2,63,18,4,1000,1:1,umh,show,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"