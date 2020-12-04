#!/bin/sh

numb='1469'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 30 --keyint 210 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.5,1.1,3.8,0.4,0.6,0.3,3,0,4,30,210,4,21,40,3,4,66,38,3,1000,-2:-2,dia,show,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"