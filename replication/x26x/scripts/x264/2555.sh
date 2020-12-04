#!/bin/sh

numb='2556'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 50 --keyint 290 --lookahead-threads 2 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,3.0,1.0,1.3,1.8,0.6,0.9,0.4,1,2,0,50,290,2,21,50,4,0,62,38,4,1000,-2:-2,hex,show,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"