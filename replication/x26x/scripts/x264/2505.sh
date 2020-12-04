#!/bin/sh

numb='2506'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 15 --keyint 270 --lookahead-threads 2 --min-keyint 21 --qp 50 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.1,0.4,0.6,0.7,0.8,1,0,6,15,270,2,21,50,3,1,64,38,3,2000,-1:-1,umh,show,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"