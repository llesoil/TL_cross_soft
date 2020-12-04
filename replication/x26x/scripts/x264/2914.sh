#!/bin/sh

numb='2915'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 45 --keyint 250 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.4,1.3,3.6,0.2,0.7,0.0,3,1,0,45,250,1,30,30,4,4,60,18,5,2000,-1:-1,hex,show,faster,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"