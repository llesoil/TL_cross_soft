#!/bin/sh

numb='2785'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 35 --keyint 250 --lookahead-threads 0 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.5,1.2,4.6,0.2,0.8,0.6,3,1,4,35,250,0,30,50,3,2,63,28,6,1000,-1:-1,hex,show,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"