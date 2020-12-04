#!/bin/sh

numb='1129'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 50 --keyint 300 --lookahead-threads 0 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.0,1.4,4.8,0.5,0.9,0.3,2,2,6,50,300,0,26,40,5,2,65,48,6,2000,-1:-1,umh,show,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"