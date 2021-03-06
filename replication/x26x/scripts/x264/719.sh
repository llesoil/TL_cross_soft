#!/bin/sh

numb='720'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 45 --keyint 250 --lookahead-threads 1 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.0,1.0,1.2,1.8,0.6,0.8,0.2,0,1,14,45,250,1,25,0,4,1,67,38,2,1000,-1:-1,hex,show,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"