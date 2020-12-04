#!/bin/sh

numb='1778'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 20 --keyint 220 --lookahead-threads 2 --min-keyint 20 --qp 0 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.4,1.0,1.6,0.3,0.7,0.0,0,1,2,20,220,2,20,0,3,2,69,28,1,2000,-2:-2,hex,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"