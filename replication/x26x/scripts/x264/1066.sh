#!/bin/sh

numb='1067'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 25 --keyint 300 --lookahead-threads 1 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.5,1.0,1.2,3.4,0.2,0.8,0.3,1,0,8,25,300,1,25,30,4,1,65,18,5,1000,-2:-2,hex,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"