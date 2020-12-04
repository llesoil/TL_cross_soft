#!/bin/sh

numb='579'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 25 --keyint 300 --lookahead-threads 2 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.5,1.0,0.4,0.3,0.6,0.5,1,2,2,25,300,2,25,0,5,0,63,38,6,2000,-2:-2,dia,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"