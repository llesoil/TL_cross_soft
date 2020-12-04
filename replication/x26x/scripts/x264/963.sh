#!/bin/sh

numb='964'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 5.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 45 --keyint 260 --lookahead-threads 1 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.1,1.2,5.0,0.6,0.9,0.8,1,0,16,45,260,1,30,10,5,3,60,38,3,2000,1:1,hex,show,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"