#!/bin/sh

numb='386'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 0 --keyint 290 --lookahead-threads 3 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.5,1.0,4.8,0.2,0.6,0.2,1,0,4,0,290,3,28,30,4,2,64,38,4,2000,-1:-1,umh,show,faster,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"