#!/bin/sh

numb='745'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 30 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset ultrafast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.2,1.3,1.8,0.3,0.7,0.7,2,2,12,30,260,0,20,0,5,2,65,38,6,2000,-2:-2,dia,crop,ultrafast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"