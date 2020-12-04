#!/bin/sh

numb='2541'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 45 --keyint 200 --lookahead-threads 0 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.2,1.0,1.8,0.6,0.8,0.4,3,2,4,45,200,0,28,50,4,4,60,28,2,1000,-2:-2,dia,show,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"