#!/bin/sh

numb='1711'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.2,1.3,2.2,0.4,0.8,0.0,1,1,8,40,260,0,28,50,4,4,68,18,1,2000,-2:-2,umh,show,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"