#!/bin/sh

numb='1752'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 45 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.5,1.1,3.4,0.2,0.9,0.8,1,1,6,45,230,2,30,20,5,1,63,38,5,2000,-2:-2,hex,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"